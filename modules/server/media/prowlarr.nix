{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.prowlarr;
in {
  options.void.server.media.prowlarr = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    services = {
      prowlarr = {
        enable = true;
      };
      nginx = {
        virtualHosts = {
          "prowlarr.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:9696";
              };
            };
          };
        };
      };
    };
  };
}
