{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.bspwm.polybar;
in
{
  options.modules.desktop.bspwm.polybar = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      polybar
    ];
    home-manager.users.sako = { pkgs, ...}: {
      xdg.configFile = {
        polybar = {
          source = ../../../../config/polybar;
          recursive = true;
        };
      };
    };
  };
}
