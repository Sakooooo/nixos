{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.navidrome;
in {
  options.void.server.media.navidrome = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    age.secrets = {
      navidrome-last-fm-secret = {
        file = ../../../secrets/server/navidrome/last-fm-secret.age;
        owner = "navidrome";
        group = "media";
      };
      navidrome-last-fm-key = {
        file = ../../../secrets/server/navidrome/last-fm-key.age;
        owner = "navidrome";
        group = "media";
      };
      navidrome-environmentFile = {
        file = ../../../secrets/server/navidrome/environmentFile.age;
        owner = "navidrome";
        group = "media";
      };
    };

    users.groups.media = {};
    services = {
      navidrome = {
        enable = true;
        group = "media";
        settings = {
          Port = 4533;
          Address = "127.0.0.1";
          MusicFolder = "/srv/media/music";
          # I hear things in my head actually
          EnableInsightsCollector = false;
          "LastFM.Enabled" = true;
          "LastFM.ApiKey" = config.age.secrets.navidrome-last-fm-key.path;
          "LastFM.Secret" = config.age.secrets.navidrome-last-fm-secret.path;
        };
      };
      nginx = {
        virtualHosts = {
          "navidrome.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:${toString config.services.navidrome.settings.Port}";
              };
            };
          };
        };
      };
    };

    systemd.services.navidrome.serviceConfig.EnvironmentFile = config.age.secrets.navidrome-environmentFile.path;
  };
}
