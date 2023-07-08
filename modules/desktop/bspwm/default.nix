{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.bspwm;
in
{
  options.modules.desktop.bspwm = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
      libinput.enable = true;
    };  
    users.users.sako.packages = with pkgs; [
      polybar
      rofi
    ];

    home-manager.users.sako = { pkgs , ...}: {
    xdg.configFile = {
      bspwm = {
        source = ../../../config/bspwm;
        };
      sxhkd = {
        source = ../../../config/sxhkd;
      };
     }; 
    };
  };
}
