{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.autobrr;
in {
  options.void.server.media.autobrr = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.groups.media = {};

    services = {
      autobrr = {
        enable = true;
        secretFile = "/srv/secrets/autobrr";
        settings = {
          checkForUpdates = true;
          host = "127.0.0.1";
          port = "7474";
        };
      };
      nginx = {
        virtualHosts = {
          "brr.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:7474";
              };
            };
          };
        };
      };
    };
    systemd.services.autobrr.serviceConfig.Group = "media";
  };
}
