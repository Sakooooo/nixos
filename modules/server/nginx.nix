{ config, lib, ... }:
with lib;
let cfg = config.void.server.nginx;
in {
  options.void.server.nginx = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    security.acme = {
      acceptTerms = true;
      defaults.email = "Sayeko@proton.me";
      defaults.group = config.services.nginx.group;
      defaults.credentialsFile = "/srv/secrets/porkbun";
      defaults.dnsProvider = "porkbun";
      defaults.webroot = null;
    };
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      commonHttpConfig = ''

        access_log /var/log/nginx/access.log combined buffer=32k flush=5m;
        error_log /var/log/nginx/error.log warn;

      '';
    };

    services.logrotate.settings.nginx = {
      enable = true;
      minsize = "50M";
      rotate = "2";
      compress = true;
    };

  };
}
