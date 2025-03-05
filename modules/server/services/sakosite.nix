{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.void.server.services.sakosite;
in {
  options.void.server.services.sakosite = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    security.acme.certs."sako.lol" = {
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };
    services = {
      nginx.virtualHosts."sako.lol" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          error_page 404 = /404.html;
        '';
        root = "/srv/static/sakosite";
      };
    };
  };
}
