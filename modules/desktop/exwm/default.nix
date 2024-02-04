{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.exwm;
in {
  options.modules.desktop.exwm = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # this needs to be enabled for gtk apps
    programs.dconf.enable = true;
    # https://nixos.wiki/wiki/XMonad
    services.xserver = {
      enable = true;
      # windowManager.exwm = {
      #   enable = true;
      # };

      windowManager.session = let
        # Allow for per-host injected desktop-related Emacs configuration.
        # extraConfig = pkgs.writeText "emacs-extra-config" ''
        #   (setq mb/system-settings
        #     '((desktop/dpi . ${(toString cfg.dpi)})
        #       (desktop/hidpi . ${
        #     if cfg.hidpi
        #     then "t"
        #     else "nil"
        #   })))
        # '';
        extraConfig = pkgs.writeText "emacs-extra-config" ''
          (require 'exwm-config)
          (exwm-config-default)
          (exwm-enable)
        '';
      in
        singleton {
          name = "exwm";
          start = ''
            # Emacs via dbus in fullscreen lol
            ${pkgs.dbus.dbus-launch} --exit-with-session emacs -mm --fullscreen \
              -l "${extraConfig}"
          '';
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
          };
        };
      };
      libinput = {
        enable = true;

        # mouse
        mouse = {
          accelProfile = "flat";
        };

        # touchpad
        touchpad = {
          accelProfile = "flat";
        };
      };
    };

    users.users.sako.packages = with pkgs; [
      #rofi
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

    environment.systemPackages = with pkgs; [
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
      # };
    };
  };
}
