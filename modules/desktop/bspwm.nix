{ options, config, lib, pkgs, ...}: 
with lib;
let cfg = config.modules.desktop.bspwm;
in {
  options.modules.desktop.bspwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
      layout = "us";
    }; 
    xdg.configFile = {
      bspwm = {
        source = ../../../config/bspwm;
      };
      sxhkd = {
        source = ../../../config/sxhkd;
      };
    }; 
    users.users.sako.packages = with pkgs; [
      rofi
      (polybar.override {
        pulseSupport = true;
       })
    ];
  };
}
