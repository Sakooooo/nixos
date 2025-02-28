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
      # okay so mediawiki sucks with postgres for some reason?
      # i wish i knew why mysql is a priority for php devs...
      mysql = {
        enable = true;
        package = pkgs.mariadb_114;
      };

      mediawiki = {
        name = "abcdef";
        enable = true;
        webserver = "nginx";
        # I hate you.
        database.type = "mysql";
        database.createLocally = true;
        nginx.hostName = "wiki.sako.box";
        uploadsDir = "/var/lib/mediawiki-uploads/";
        # password or something go change this to agenix secret latre
        passwordFile = "/srv/secrets/wikimedia-admin";
        extraConfig = ''
          // Disable email requirement
          $wgEnableEmail = false;
          // Nobody can read or edit
          $wgGroupPermissions['*']['edit'] = false;
          $wgGroupPermissions['*']['read'] = false;
          // ...without an account
          $wgGroupPermissions['users']['edit'] = true;
          $wgGroupPermissions['users']['read'] = true;

          // Disable account creation, only SysOps can make accounts
          $wgGroupPermissions['*']['createaccount'] = false; // REQUIRED to enforce account requests via this extension

          $wgDefaultSkin = 'vector';

          // InviteSignup plugin
          $wgGroupPermissions['sysop']['invitesignup'] = true;
        '';
        extensions = {
          VisualEditor = null;
          InviteSignup = pkgs.fetchzip {
            url = "https://extdist.wmflabs.org/dist/extensions/InviteSignup-REL1_43-8eb3d0a.tar.gz";
            hash = "sha256-ik8rX6kyk4SqARgMrgp4XP7/J0smjAXlq6JGtlFhICo=";
          };
        };
      };
      nginx.virtualHosts."wiki.sako.box" = {
        forceSSL = true;
        sslCertificate = "/srv/secrets/certs/sako.box.pem";
        sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
      };
    };
  };
}
