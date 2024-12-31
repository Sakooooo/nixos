{ config, lib, ... }:
with lib;
let cfg = config.void.services.forgejo;
in {
  options.void.server.forgejo = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      # settings = { };
    };
  };
}
