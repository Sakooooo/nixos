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
        settings = {
          title = "sakoserver";
          description = "sakoserver";
          target = "_self";
        };
        widgets = [{
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }];
        services = [
          {
            "Media" = [ ] ++ lib.optionals srv.media.jellyfin.enable [{
              "Jellyfin" = {
                description = "media server";
                href = "https://jellyfin.sako.box";
                icon = "jellyfin.svg";
              };
            }] ++ lib.optionals srv.media.qbittorrent.enable [{
              "QBittorrent" = {
                description = "Thing";
                href = "https://qbittorrent.sako.box";
                icon = "qbittorrent.svg";
              };
            }] ++ lib.optionals srv.services.local.miniflux.enable [{
              "Miniflux" = {
                description = "RSS Reader";
                href = "https://rss.sako.box";
                icon = "miniflux.svg";
              };
            }];
          }
          {
            "Services" = [ ] ++ lib.optionals srv.services.forgejo.enable [{
              "Forgejo" = {
                description = "Selfhosted Git Forge";
                icon = "forgejo.svg";
                href = "https://git.sako.lol";
              };
            }] ++ lib.optionals srv.services.woodpecker.enable [{
              "Woodpecker CI" = {
                description = "Selfhosted CI";
                icon = "woodpecker.svg";
                href = "https://ci.sako.lol";
              };
            }] ++ lib.optionals srv.fedi.akkoma.enable [{
              "Akkoma" = {
                description = "Fediverse";
                icon = "akkoma.svg";
                href = "https://fedi.sako.lol";
              };
            }] ++ lib.optionals srv.services.redlib.enable [{
              "Redlib" = {
                icon = "redlib.svg";
                description = "privacy friendly reddit frontend";
                href = "https://redlib.sako.box";
              };
            }] ++ lib.optionals srv.services.local.nextcloud.enable [{
              "Nextcloud" = {
                icon = "nextcloud.svg";
                description = "selfhosted cloud";
                href = "https://nextcloud.sako.box";
              };
            }] ++ lib.optionals srv.services.sakosite.enable [{
              "Site" = {
                icon = "https://sako.lol/icon.png";
                description = "personal site";
                href = "https://sako.lol";
              };
            }];
          }
        ];
      };
    };
  };

}
