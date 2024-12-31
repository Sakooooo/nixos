{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.forgejo;
in {
  options.void.server.services.forgejo = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      # settings = {

      # };
    };
  };
}
