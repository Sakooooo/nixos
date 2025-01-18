{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.local.miniflux;
in {
  options.void.server.services.local.miniflux = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services = {
      miniflux = {
        enable = true;
        adminCredentialsFile = "/srv/secrets/miniflux.env";
        config = {
          LISTEN_ADDR = "localhost:7665";
          BASE_URL = "https://rss.sako.box";
        };
      };
      nginx.virtualHosts."rss.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = { proxyPass = "http://localhost:7665"; };
      };
    };

  };
}
