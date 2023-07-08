{ options, config, lib, pkgs, ...}:
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
    };  
    users.users.sako.packages = with pkgs; [
      kitty
    ];

    home-manager.users.sako = { pkgs , ...}: {
    xdg.configFile = {
      kitty = {
        source = ../../../config/kitty;
        };
      }; 
    };
  };
}
