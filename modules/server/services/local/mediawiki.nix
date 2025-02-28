{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  srv = config.void.server;
  cfg = config.void.server.services.local.mediawiki;
in {
  options.void.server.services.local.mediawiki = {enable = mkEnableOption false;};

  # How overkill is this again?

  config = mkIf cfg.enable {
    services = {
      mediawiki = {
        name = "abcdef";
        enable = true;
        webserver = "nginx";
        database.type = "postgres";
        nginx.hostname = "wiki.sako.box";
        uploadsDir = "/var/lib/mediawiki-uploads/";
        # password or something go change this to agenix secret later
        passwordFile = "/srv/secrets/wikimedia-admin";
        extraConfig = ''
          $wgGroupPermissions['*']['edit'] = false;
        '';
      };
      nginx.virtualHosts."wiki.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
      };
    };
  };
}
