{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.jellyfin;
in {
  options.void.server.media.jellyfin = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.groups.media = {};

    services = {
      jellyfin = {
        enable = true;
        group = "media";
        # television
        openFirewall = true;
      };

      nginx = {
        virtualHosts = {
          "jellyfin.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:8096";
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
