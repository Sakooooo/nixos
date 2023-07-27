{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.transmission.daemon;
in
{
  options.modules.desktop.apps.transmission.daemon = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    
  };
}
