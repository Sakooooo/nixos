{ config, lib, ... }:
with lib;
let cfg = config.void.server.local.nextcloud;
in {
  options.void.server.services.local.nextcloud = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # thank you again notashelf lmao
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud30;

        https = true;
        hostName = "nextcloud.sako.box";
        nginx = { recommendedHttpHeaders = true; };

        autoUpdateApps = {
          enable = true;
          startAt = "03:00";
        };

        caching = {
          apcu = true;
          memcached = true;
          redis = true;
        };

        config = {
          dbtype = "pgsql";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          dbuser = "nextcloud";
        };
        settings = {
          maintenance_window_start = 1;
          trusted_domains = [ "https://nextcloud.sako.box" ];
          trusted_proxies = [ "https://nextcloud.sako.box" ];

          redis = {
            host = "/run/redis-nextcloud";
            dbindex = 0;
            timeout = 3;
          };
          default_phone_region = "AE";
          lost_password_link = "disabled";
        };
        phpOptions = {
          "opcache.enable" = "1";
          "opcache.enable_cli" = "1";
          "opcache.validate_timestamps" = "0";
          "opcache.save_comments" = "1";

          # <https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html>
          "opcache.jit" = "1255";
          "opcache.jit_buffer_size" = "256M";

          # fix the opcache "buffer is almost full" error in admin overview
          "opcache.interned_strings_buffer" = "16";
          # try to resolve delays in displaying content or incomplete page rendering
          "output_buffering" = "off";

          "pm" = "dynamic";
          "pm.max_children" = "50";
          "pm.start_servers" = "15";
          "pm.min_spare_servers" = "15";
          "pm.max_spare_servers" = "25";
          "pm.max_requests" = "500";
        };
      };
      nginx.virtualHosts."nextcloud.sako.box" = {
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
      };
    };
  };
  systemd.services = {
    phpfpm-nextcloud.aliases = [ "nextcloud.service" ];
    "nextcloud-setup" = {
      requires = [ "postgresql.service" "redis-nextcloud.service" ];
      after = [ "postgresql.service" "redis-nextcloud.service" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
