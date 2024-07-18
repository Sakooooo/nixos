{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
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

    services.displayManager.defaultSession = "none+i3";

    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
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
      # xdg.configFile = {
      #   sxhkd = {
      #     source = ../../../config/sxhkd;
      #   };
      # };
    };
  };
}
