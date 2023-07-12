{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.bspwm.lemonbar;
in
{
  options.modules.desktop.bspwm.lemonbar = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
     lemonbar-xft  
    ];
    home-manager.users.sako = { pkgs, ...}: {
      xdg.configFile = {
        lemonbar = {
          source = ../../../../config/lemonbar;
          recursive = true;
        };
      };
    };
  };
}
