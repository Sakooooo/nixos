{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  srv = config.void.server;
  cfg = config.void.server.services.local.soju;
in {
  options.void.server.services.local.soju = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.groups.soju = {};
    users.users.soju = {
      isSystemUser = true;
      group = "soju";
    };

    networking.firewall.allowedTCPPorts = [6697 6698];
    services = {
      soju = {
        enable = true;
        hostName = "irc.sako.box";
        listen = [
          ":6697"
          "wss://:6698"
        ];
        tlsCertificate = "/srv/secrets/soju-certs/sako.box.pem";
        tlsCertificateKey = "/srv/secrets/soju-certs/sako.box-key.pem";
        httpOrigins = ["*"];
      };
      nginx.virtualHosts."irc.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = {
          root = let
            gamja = pkgs.compressDrvWeb (pkgs.gamja.override {
              gamjaConfig = {
                server = {
                  url = "irc.sako.box:6698";
                  nick = "sako";
                };
              };
            }) {};
          in "${gamja}";
        };
      };
    };

    systemd.services.soju.serviceConfig = {
      User = "soju";
      Group = "soju";
    };

    systemd.services.soju.after = lib.mkIf (srv.proxies.enable) ["wireproxy.service"];
    # TODO:: SystemD service to run netcat and proxy connections
  };
}
