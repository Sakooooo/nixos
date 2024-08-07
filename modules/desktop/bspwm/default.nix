{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.bspwm;
in {
  imports = [
    ./polybar
    ./lemonbar
  ];
  options.modules.desktop.bspwm = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    # this is needed for gtk configuration to work
    programs.dconf.enable = true;

    # keyring
    services.gnome.gnome-keyring.enable = true;

    # ????????????
    services.libinput = {
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

    # why???????????????????????
    services.displayManager.defaultSession = "none+bspwm";

    services.xserver = {
      enable = true;
      windowManager = {
        bspwm.enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../../config/background.png;
          greeters.mini = {
            enable = true;
            user = "sako";
            extraConfig = ''
              [greeter]
              show-password-label = true
              password-label-text = magic word
              invalid-password-text = skull issue

            '';
          };
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

    home-manager.users.sako = {pkgs, ...}: {
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
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
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
