{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.services.big-brother;
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  imports = [inputs.big-brother.nixosModules.default];
  options.void.server.services.big-brother = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    services.big-brother = {
      enable = true;
      port = 43523;
      environmentFile = "/srv/secrets/big-brother.env";
    };
    security.acme.certs."big-brother.sako.lol" = {
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };
    services.nginx.virtualHosts."big-brother.sako.lol" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:43523";
      };
    };
  };
}
