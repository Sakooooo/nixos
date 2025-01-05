{ config, lib, pkgs, ... }:
with lib;
let cfg = config.void.server.media.jellyfin;
in {
  options.void.server.media.jellyfin = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    users.groups.media = { };

    services = {
      jellyfin = {
        enable = true;
        group = "media";
        # television
        openFirewall = true;
      };

      nginx = {
        proxyCachePath."jellyfin" = {
          enable = true;
          levels = "1:2";
          inactive = "1w";
          maxSize = "5g";
          useTempPath = false;
          keysZoneName = "jellyfin_cache";
          keysZoneSize = "10m";
        };
        virtualHosts = {
          "jellyfin.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            extraConfig = ''
                      add_header X-Frame-Options "SAMEORIGIN";
                      add_header X-Content-Type-Options "nosniff";
              add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;
              add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'";

            '';
            locations = {
              "/" = {
                proxyPass = "http://localhost:8096";
                extraConfig = ''
                                    # Disable buffering when the nginx proxy gets very resource heavy upon streaming
                                    proxy_buffering off;
                  proxy_cache jellyfin_cache;
                '';
              };
              "/socket" = {
                proxyPass = "http://localhost:8096";
                proxyWebsockets = true;
              };
            };
          };
        };
      };
    };
  };
}
