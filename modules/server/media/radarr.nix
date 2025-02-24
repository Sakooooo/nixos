{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.radarr;
in {
  options.void.server.media.radarr = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.groups.media = {};

    services = {
      radarr = {
        enable = true;
        group = "media";
      };
      nginx = {
        virtualHosts = {
          "radarr.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:7878";
              };
            };
          };
        };
      };
    };
  };
}
