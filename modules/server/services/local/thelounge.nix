{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  srv = config.void.server;
  cfg = config.void.server.services.local.thelounge;
in {
  options.void.server.services.local.thelounge = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    services = {
      thelounge = {
        enable = true;
        public = false;
        port = 9543;
        plugins = with pkgs.nodePackages; [
          thelounge-theme-mininapse
          thelounge-theme-amoled
        ];
      };
      nginx.virtualHosts."irc.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
        locations."/" = {proxyPass = "http://localhost:9543";};
      };
    };

    systemd.services.thelounge.after = lib.mkIf (srv.proxies.enable) ["wireproxy.service"];
  };
}
