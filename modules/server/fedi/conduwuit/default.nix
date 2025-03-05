{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.void.server.fedi.matrix;
in {
  options.void.server.fedi.matrix = {enable = mkEnableOption false;};

  # :(
  config = mkIf cfg.enable {
    security.acme.certs = {
      "matrix.sako.lol" = {
        credentialsFile = "/srv/secrets/porkbun";
        dnsProvider = "porkbun";
        webroot = null;
      };
    };

    services = {
      matrix-conduit = {
        enable = true;
        package = inputs.conduwuit.packages.${pkgs.system}.default;
        settings.global = {
          port = 6167;
          server_name = "sako.lol";
          max_request_size = 50000000; # 50mb
          allow_public_room_directory_over_federation = true;
          database_backend = "rocksdb";
          allow_registration = false;
          new_user_displayname_suffix = "^w^";
          trusted_servers = ["matrix.org"];
          # rocksdb_optimize_for_spinning_disks = true;
        };
      };
      nginx.virtualHosts = {
        "matrix.sako.lol" = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://localhost:6167";
        };
        "sako.lol" = {
          locations."/.well-known/matrix/client" = {
            extraConfig = ''
              return 200 '{"m.homeserver": {"base_url": "https://matrix.sako.lol"}}';
              add_header Content-Type application/json;
              add_header Access-Control-Allow-Origin *;
            '';
          };
          locations."/.well-known/matrix/server" = {
            extraConfig = ''
              return 200 '{"m.server": "matrix.sako.lol:443"}';
              add_header Content-Type application/json;
              add_header Access-Control-Allow-Origin *;
            '';
          };
        };
      };
    };
  };
}
