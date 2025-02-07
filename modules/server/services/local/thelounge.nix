{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.void.server.services.local.thelounge;
in {
  options.void.server.services.local.thelounge = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    # TODO Maybe make this a public instance? idk
    services = {
      thelounge = {
        enable = true;
        public = false;
        port = 9543;
        plugins = with pkgs.nodePackages; [
          thelounge-theme-mininapse
        ];
      };
    };
    nginx.virtualHosts."irc.sako.box" = {
      forceSSL = true;
      sslCertificate = "/srv/secrets/certs/sako.box.pem";
      sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
      locations."/" = {proxyPass = "http://localhost:8284";};
    };
  };
}
