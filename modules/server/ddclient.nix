{ config, lib, pkgs, ... }:
with lib;
let cfg = config.void.server.ddclient;
in {
  options.void.server.ddclient = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services.ddclient = {
      enable = true;
      configFile = "/srv/secrets/ddclient.conf";
    };
  };
}

