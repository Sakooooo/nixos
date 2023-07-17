{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.bspwm;
in
{
  imports = [
    ./polybar
    ./lemonbar
  ];
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
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.vimix-gtk-themes;
            name = "vimix-dark-ruby";
          };
          iconTheme = {
            package = pkgs.vimix-icon-theme;
            name = "Vimix Ruby dark";
          };
          cursorTheme = {
            package = pkgs.catppuccin-cursors.mochaDark;
            name = "Catppuccin-Mocha-Dark";
          };
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
      rofi
      # network
      networkmanagerapplet
      # brightness
      brightnessctl
      # gee tee k
      vimix-gtk-themes
      vimix-icon-theme
      lxappearance
      catppuccin-cursors.mochaDark
      # screen shot (s)
      flameshot
    ];

    home-manager.users.sako = { pkgs , ...}: {
      home.pointerCursor = {
        name = "Catppuccin-Mocha-Dark"; 
        size = 16;
        x11 = {
          enable = true;
        };
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
      };
      gtk = {
        theme.name = "vmix-dark-ruby";
        iconTheme.name = "Vimix Ruby Dark";
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
