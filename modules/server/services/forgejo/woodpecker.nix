{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.void.server.services.forgejo.woodpecker;
  domain = "ci.sako.lol";
in {
  options.void.server.services.forgejo.woodpecker = {
    enable = mkEnableOption false;
  };
  config = mkIf cfg.enable {
    security.acme.certs."ci.sako.lol" = {
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };

    users = {
      groups.woodpecker = {};
      users.woodpecker = {
        group = "woodpecker";
        isSystemUser = lib.mkDefault true;
      };
    };

    # LOL get it, a man is in a pod LMAO XDDDDD ROFL
    # virtualisation.podman = {
    #   enable = true;
    #   defaultNetwork.settings = {
    #     # dns_enabled = true;
    #     dns = "127.0.0.1";
    #   };
    # };
    virtualisation.docker.enable = true;

    # # This is needed for podman to be able to talk over dns
    # networking.firewall.interfaces."podman0" = {
    #   allowedUDPPorts = [ 53 ];
    #   allowedTCPPorts = [ 53 ];
    # };

    services = {
      woodpecker-server = {
        enable = true;
        environment = {
          WOODPECKER_HOST = "https://${domain}";
          WOODPECKER_SERVER_ADDR = ":3007";
          WOODPECKER_FORGEJO = "TRUE";
          WOODPECKER_FORGEJO_URL = "https://git.sako.lol";
          WOODPECKER_FORGE_TIMEOUT = "30s";
          WOODPECKER_FORGE_RETRY = "10";
          WOODPECKER_OPEN = "TRUE";
          WOODPECKER_ADMIN = "sako";
          WOODPECKER_DATABASE_DRIVER = "postgres";
          WOODPECKER_DATABASE_DATASOURCE = "postgres:///woodpecker?host=/run/postgresql";
        };
        # /srv/secrets/woodpecker-server.env
        # WOODPECKER_AGENT_SECRET=XXXXXXXXXXXXXXXXXXXXXX
        # WOODPECKER_FORGEJO_CLIENT=YOUR_FORGEJO_CLIENT
        # WOODPECKER_FORGEJO_SECRET=YOUR_FORGEJO_CLIENT_SECRET
        environmentFile = "/srv/secrets/woodpecker-server.env";
      };
      woodpecker-agents.agents."sakoserver-agent" = {
        enable = true;
        # We need this to talk to the podman socket
        extraGroups = ["docker"];
        environment = {
          WOODPECKER_SERVER = "localhost:9000";
          WOODPECKER_MAX_WORKFLOWS = "1";
          # DOCKER_HOST = "unix:///run/podman/podman.sock";
          WOODPECKER_BACKEND = "docker";
          WOODPECKER_HEALTHCHECK_ADDR = ":3001";
        };
        # Same as with woodpecker-server
        # WOODPECKER_AGENT_SECRET goes here too idiot
        environmentFile = ["/srv/secrets/woodpecker.env"];
      };
      nginx.virtualHosts."${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://localhost:3007";};
      };
    };
    systemd.services.woodpecker-server.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "woodpecker";
    };
  };
}
