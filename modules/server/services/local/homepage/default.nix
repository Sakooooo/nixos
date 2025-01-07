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
          "Media" = [ ] ++ mkIf srv.media.jellyfin.enable [{
            "Jellyfin" = {
              description = "media server";
              href = "https://jellyfin.sako.box";
              icon = "jellyfin.svg";
            };
          }];
          "Services" = [ ] ++ mkIf srv.services.forgejo.enable [{
            "Forgejo" = {
              description = "Selfhosted Git Forge";
              icon = "forgejo.svg";
              href = "https://git.sako.lol";
            };
          }] ++ mkIf srv.fedi.akkoma.enable [{
            "Akkoma" = {
              description = "Fediverse";
              icon = "akkoma.svg";
              href = "https://fedi.sako.lol";
            };
          }] ++ mkIf srv.services.redlib.enable [{
            "Redlib" = {
              icon = "redlib.svg";
              description = "privacy friendly reddit frontend";
              href = "https://redlib.sako.box";
            };
          }] ++ mkIf srv.services.local.nextcloud.enable [{
            "Nextcloud" = {
              icon = "nextcloud.svg";
              description = "selfhosted cloud";
              href = "https://nextcloud.sako.box";
            };
          }] ++ mkIf srv.services.sakosite.enable [{
            "Site" = {
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
