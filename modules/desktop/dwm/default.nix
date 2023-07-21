{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.dwm;
in
{
  options.modules.desktop.dwm = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager = {
        dwm.enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk = {
            enable = true;
            background = ../../../config/background.png;
            theme = {
              name = "vimix-dark-ruby";
              package = pkgs.vimix-gtk-themes;
            };
          };
        };
      };
    libinput = {
      mouse = {
        accelProfile = "flat";
      };

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
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
      };
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
        theme.name = "vimix-dark-ruby";
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
