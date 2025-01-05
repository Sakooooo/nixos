{ config, pkgs, lib, ... }:
with lib;
let
  inherit (lib) mkIf;
  cfg = config.void.server.services.local.homepage;
  srv = config.void.server;
in {
  options.void.server.services.local.homepage = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services = {
      nginx.virtualHosts."sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = { proxyPass = "http://localhost:8082"; };
      };
      homepage-dashboard = {
        enable = true;
        widgets = [{
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }];
        services = [{
          "Media" = [{
            "Jellyfin" = mkIf srv.media.jellyfin.enable {
              description = "Media server";
              href = "https://jellyfin.sako.box";
            };
          }];
        }];
      };
    };
  };

}
