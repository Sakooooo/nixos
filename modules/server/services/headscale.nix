{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.headscale;
in {
  options.void.server.services.headscale = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # THANK YOU NOTASHLEF 
    environment.systemPackages =
      [ config.services.headscale.package pkgs.tailscale ];

    services.tailscale.enable = true;

    services.headscale = {
      enable = true;
      package = pkgs.headscale;
      address = "127.0.0.1";
      port = 8085;

      settings = {
        server_url = "https://headscale.sako.lol";
        grpc_listen_addr = "127.0.0.1:50443";
        grpc_allow_insecure = false;
        prefixes = {
          allocation = "sequential";
          v4 = "100.64.0.0/10";
          v6 = "fd7a:115c:a1e0::/48";
        };
        database = {
          type = "sqlite3";
          debug = false;
          sqlite.path = "/var/lib/headscale/db.sqlite";
          # GORM configuration settings.
          gorm = {
            # Enable prepared statements.
            prepare_stmt = true;

            # Enable parameterized queries.
            parameterized_queries = true;

            # Skip logging "record not found" errors.
            skip_err_record_not_found = true;

            # Threshold for slow queries in milliseconds.
            slow_threshold = 1000;
          };
        };
        metrics_listen_addr = "127.0.0.1:8086";
        randomize_client_port =
          false; # prefer a random port for WireGuard traffic over
        disable_check_updates = true; # disable checking for updates on startup
        ephemeral_node_inactivity_timeout =
          "30m"; # time before an e ephemeral node is deleted.
        node_update_check_interval = "10s";

        # Unix socket used for the CLI to connect without authentication
        unix_socket = "/run/headscale/headscale.sock";
        unix_socket_permission = "0770";

        # logging
        log = {
          format = "text";
          level = "info";
        };

        services.nginx.virtualHosts."headscale.sako.lol" = {
          forceSSL = true;
          enableACME = true;
          http3 = true;

          locations = {
            "/" = {
              proxyPass =
                "http://localhost:${toString config.services.headscale.port}";
              proxyWebsockets = true;
            };
          };
          extraConfig = ''
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
          '';
        };

        security.acme.certs."headscale.sako.lol" = { };

        systemd.services = { tailscaled.after = [ "headscale.service" ]; };

      };
    };
  };
}
