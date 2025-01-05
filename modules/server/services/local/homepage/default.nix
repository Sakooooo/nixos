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
              icon = "jellyfin.svg";
              description = "Media server";
              href = "https://jellyfin.sako.box";
            };
          }];
          "Services" = [{
            "Forgejo" = mkIf srv.services.forgejo.enable {
              icon = "forgejo.svg";
              description = "Selfhosted Git Forge";
              href = "https://git.sako.lol";
            };
            "Akkoma" = mkIf srv.fedi.akkoma.enable {
              icon = "akkoma.svg";
              description = "Selfhosted Fediverse thing";
              href = "https://fedi.sako.lol";
            };
            "Redlib" = mkIf srv.services.redlib.enable {
              icon = "redlib.svg";
              description = "privacy friendly reddit frontend";
              href = "https://redlib.sako.box";
            };
            "Nextcloud" = mkIf srv.services.local.nextcloud.enable {
              icon = "nextcloud.svg";
              description = "cloud";
              href = "https://nextcloud.sako.box";
            };
            "Site" = mkIf srv.services.sakosite.enable {
              icon = "https://sako.lol/icon.png";
              description = "personal site";
              href = "https://sako.lol";
            };
          }];
        }];
      };
    };
  };

}
