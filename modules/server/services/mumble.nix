{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.mumble;
in {
  options.void.server.services.mumble = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services = {
      murmur = {
        enable = true;
        port = 56734;
        openFirewall = true;
        welcometext = "sako.lol!";
        sslKey = "/var/lib/acme/mumble.sako.lol/key.pem";
        sslCert = "/var/lib/acme/mumble.sako.lol/fullchain.pem";
        bandwidth = 72000;
        clientCertRequired = true;
      };
    };

    security.acme.certs."mumble.sako.lol" = {
      group = config.services.murmur.group;
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };

  };
}
