{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.void.server.services.forgejo;
in {
  imports = [./runner.nix ./woodpecker.nix ./pages.nix];
  options.void.server.services.forgejo = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [22];

    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        DEFAULT = {
          APP_NAME = "void-git";
          APP_SLOGAN = "Now on NixOS!";
        };

        database = {
          DB_TYPE = "postgres";
          HOST = "/run/postgresql";
          NAME = "forgejo";
          USER = "forgejo";
          PASSWD = "forgejo";
        };

        cache = {
          ENABLED = true;
          ADAPTER = "redis";
          HOST = "redis://forgejo@localhost:6371";
        };
        "ui.meta" = {
          AUTHOR = "sako!";
          DESCRIPTION = "Something is happening...";
        };

        service.DISABLE_REGISTRATION = true;
        "service.explore" = {
          REQUIRE_SIGNIN_VIEW = true;
          DISABLE_USERS_PAGE = true;
          DISABLE_ORGANIZATIONS_PAGE = true;
          DISABLE_CODE_PAGE = true;
        };

        server = {
          ROOT_URL = "https://git.sako.lol";
          DOMAIN = "git.sako.lol";
          START_SSH_SERVER = true;
          SSH_PORT = 22;
          SSH_LISTEN_PORT = 22;
        };
        session = {
          PROVIDER = "redis";
          PROVIDER_CONFIG = "redis://:forgejo@localhost:6371";
        };
      };
    };
    services.nginx.virtualHosts = {
      "git.sako.lol" = {
        forceSSL = true;
        enableACME = true;
        http3 = true;
        locations."/" = {proxyPass = "http://localhost:3000";};
      };
    };

    services.fail2ban.jails.forgejo = {
      settings = {
        filter = "forgejo";
        action = "iptables-multiport";
        mode = "aggressive";
        maxretry = 5;
        findtime = 3600;
        bantime = 900;
      };
    };
    security.acme.certs."git.sako.lol" = {
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };
    environment.etc = {
      "fail2ban/filter.d/forgejo.conf".text = ''
        [Definition]
        failregex = ^.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>$
        journalmatch = _SYSTEMD_UNIT=forgejo.service
      '';
    };
    systemd.services.forgejo = {
      after = ["postgresql.service" "redis-forgejo.service"];
      serviceConfig = {
        AmbientCapabilities = lib.mkForce ["CAP_NET_BIND_SERVICE"];
        CapabilityBoundingSet = lib.mkForce ["CAP_NET_BIND_SERVICE"];
        PrivateUsers = lib.mkForce false;
      };
    };
  };
}
