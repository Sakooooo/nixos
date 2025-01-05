{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.redlib;
in {
  options.void.server.services.redlib = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # TODO Maybe make this a public instance? idk
    services = {
      redlib = {
        enable = true;
        address = "127.0.0.1";
        port = "8284";
        settings = {
          REDLIB_DEFAULT_WIDE = "on";
          REDLIB_DEFAULT_USE_HLS = "on";
          REDLIB_DEFAULT_THEME = "black";
          # Never goon
          REDLIB_SFW_ONLY = "on";
          REDLIB_ROBOTS_DISABLE_INDEXING = "on";
          REDLIB_BANNER = "welcome to sako.lol's redlib or whatever";
        };
      };
      nginx.virtualHosts."redlib.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = { proxyPass = "http://localhost:8284";- };
      };
    };

  };
}
