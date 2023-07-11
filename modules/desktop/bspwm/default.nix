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
      };
      displayManager = {
       defaultSession = "none+bspwm"; 
       lightdm = {
        enable = true;
        background = ../../../config/bspwm/background.png;
        greeters.mini = {
          enable = true;
          user = "sako";
          extraConfig = ''
            [greeter]
            show-password-label = true 
            password-label-text = whats the magic word?
            [greeter-theme]
            password-border-color = "#08090e"
            password-border-width = 1px
          '';
        };
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
      # network
      networkmanagerapplet
      # brightness
      brightnessctl
    ];

    home-manager.users.sako = { pkgs , ...}: {
      gtk = {
        enable = true;
        theme = {
          name = "Vimix-dark";
          package = pkgs.vimix-gtk-themes;
        };
      };
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
