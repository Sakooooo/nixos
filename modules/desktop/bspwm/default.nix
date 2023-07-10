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
      windowManager = {
        bspwm.enable = true;
        defaultSession = "bspwm"; 
      };
      displayManager.lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "sako";
          extraConfig = ''
            [greeter]
            show-password-label = true
            [greeter-theme]
            background-image = "/home/sako/background.png"
          '';
        };
      };
      libinput = {
        enable = true;

        # no mouse accel
        mouse = {
          accelProfile = "flat";
        };

        # no touchpad accel
        touchpad = {
          accelProfile = "flat";
        };
      };
    };  
    users.users.sako.packages = with pkgs; [
      polybar
      rofi
      networkmanagerapplet
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
