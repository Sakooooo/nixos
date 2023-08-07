{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.dwm;
in {
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
        defaultSession = "none+dwm";
        lightdm = {
          enable = true;
          background = ../../../config/background.png;
          greeters.mini = {
            enable = true;
            user = "sako";
            extraConfig = ''
              [greeter]
              show-password-label = true
              password-label-text = "magic word"
              invalid-password-text = "skull issue"

            '';
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
    home-manager.users.sako = {pkgs, ...}: {
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
        ".dwmscripts" = {
          enable = true;
          source = ../../../config/dwm/scripts;
          recursive = true;
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
    };
  };
}
