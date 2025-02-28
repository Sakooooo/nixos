# this pr https://github.com/NixOS/nixpkgs/pull/370864
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption;
  inherit (lib) types;

  cfg = config.void.server.services.forgejo.pages;
in {
  meta.maintainers = with lib.maintainers; [ NotAShelf ];

  options = {
    void.server.services.forgejo.pages = {
      enable = mkEnableOption "Codeberg pages server";
      package = mkPackageOption pkgs "codeberg-pages" { };
      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/codeberg-pages";
        description = "Directory in which state will be stored";
      };

      user = mkOption {
        type = types.str;
        default = "codeberg-pages";
        description = "User account under which Codeberg Pages will run.";
      };

      group = mkOption {
        type = types.str;
        default = "codeberg-pages";
        description = "Group under under which Codeberg Pages will run.";
      };

      settings = mkOption {
        type = with types; submodule { freeformType = attrsOf str; };
        default = { };
        example = {
          ACME_ACCEPT_TERMS = true;
          ENABLE_HTTP_SERVER = true;

          GITEA_ROOT = "git.exampledomain.tld";
        };

        description = ''
          Configuration values to be passed to the codeberg pages server
          as environment variables.
          [pages-server documentation]: https://codeberg.org/Codeberg/pages-server#environment-variables
          See [pages-server documentation] for available options.
          For sensitive values, prefer using {option}`services.pages-server.environmentFile`.
        '';
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/secret/pages-server.env";
        description = ''
          An environment file as defined in {manpage}`systemd.exec(5)`.
          Sensitive information, such as `GITEA_API_TOKEN`, may be passed
          to the service without adding them to the world-readable Nix store.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.rules =
        [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -" ];

      services.codeberg-pages = {
        description = "Codeberg Pages Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = cfg.settings;
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = cfg.stateDir;
          WorkingDirectory = cfg.stateDir;
          ReadWritePaths = [ cfg.stateDir ];
          ExecStart = "${lib.getExe cfg.package}";
          EnvironmentFile =
            lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          Restart = "on-failure";
          # Security section directly mimics the one of Forgejo module
          # Capabilities
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"
            "setrlimit"
          ];
        };
      };
    };

    users.users = mkIf (cfg.user == "codeberg-pages") {
      codeberg-pages = {
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups =
      mkIf (cfg.group == "codeberg-pages") { codeberg-pages = { }; };

    services.nginx.virtualHosts = {
      "pages.sako.lol" = {
        # listen = [{
        #   addr = "0.0.0.0";
        #   port = 443;
        #   # ssl = true;
        # }];
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          proxy_ssl_server_name on;
        '';
        locations."/" = { proxyPass = "https://localhost:4563"; };
      };
      "*.pages.sako.lol" = {
        # listen = [{
        #   addr = "0.0.0.0";
        #   port = 443;
        #   # ssl = true;
        # }];
        forceSSL = true;
        useACMEHost = "pages.sako.lol";
        extraConfig = ''
          proxy_ssl_server_name on;
        '';
        locations."/" = { proxyPass = "https://localhost:4563"; };
      };
    };
    security.acme.certs."pages.sako.lol" = {
      extraDomainNames = [ "*.pages.sako.lol" ];
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };
    # services.nginx.streamConfig = ''
    #    server {
    #     server_name *.pages.sako.lol;
    #     listen 55342 ssl;

    #     ssl_certificate /var/lib/acme/pages.sako.lol/fullchain.pem;
    #     ssl_certificate_key /var/lib/acme/pages.sako.lol/key.pem;

    #     proxy_connect_timeout 1s;
    #     proxy_timeout 3s;

    #     proxy_pass https://localhost:4563;       
    #     ssl_preread on;
    #   }
    # '';
  };
}
