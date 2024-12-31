{ config, lib, ... }:
with lib;
let cfg = config.void.server.nginx;
in {
  imports = [ ./dns ];

  options.void.server.nginx = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "Sayeko@proton.me";
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
        access_log /var/log/nginx/access.log combined_anon buffer=32k flush=5m;
        error_log /var/log/nginx/error.log warn;
      '';
    };

  };
}
