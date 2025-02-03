{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.void.server.services.wakapi;
in {
  options.void.server.services.wakapi = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    services = {
      wakapi = {
        enable = true;
        passwordSaltFile = "/srv/secrets/wakapi-salt";

        settings = {
          server = {
            port = 8953;
            public_url = "https://wakapi.sako.box";
          };
          db = {
            dialect = "postgres";
            host = "/run/postgresql";
            port = 5432;
            name = "wakapi";
            user = "wakapi";
          };
          security = {
            allow_signup = false;
            disable_frontpage = true;
          };
        };
      };
      nginx.virtualHosts."wakapi.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = {proxyPass = "http://localhost:8953";};
      };
    };
  };
}
