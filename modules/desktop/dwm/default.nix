{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.dwm;
in {
  options.modules.desktop.dwm = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    # this needs to be enabled for gtk apps
    programs.dconf.enable = true;
    # enable dwm
    services.displayManager.defaultSession = "none+dwm";

    services.xserver = {
      enable = true;
      windowManager = {
        dwm.enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../../config/background.png;
          greeters.gtk = {
            enable = true;
            theme = {
              name = "vimix-dark-ruby";
              package = pkgs.vimix-gtk-themes;
            };
            cursorTheme = {
              name = "Catppuccin-Mocha-Dark";
              size = 16;
              package = pkgs.catppuccin-cursors.mochaDark; 
            };
          };
        #  greeters.mini = {
        #    enable = true;
        #    user = "sako";
        #    extraConfig = ''
        #      [greeter]
        #      show-password-label = true
        #      password-label-text = magic word
        #      invalid-password-text = skull issue
        #    '';
        #  };
        };
      };
    };

    services.libinput = {
      mouse = {
        accelProfile = "flat";
      };

      touchpad = {
        accelProfile = "flat";
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
      # clipboard
      xclip
    ];
    home-manager.users.sako = {pkgs, ...}: {
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
        ".dwmscripts" = {
          enable = true;
          recursive = true;
          source = ../../../config/dwmbar;
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
        enable = true;
        theme.name = "vimix-dark-ruby";
        iconTheme.name = "Vimix Ruby Dark";
      };
    };
  };
}
