{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.exwm;
  imports = [
    ../../dev/editors/emacs
  ];
in {
  options.modules.desktop.exwm = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    modules.dev.editors.emacs.daemon = lib.mkForce false;
    modules.dev.editors.emacs.enable = lib.mkForce true;
    # this needs to be enabled for gtk apps
    programs.dconf.enable = true;

    # keyring
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;

    services.xserver = {
      enable = true;
      # windowManager.exwm = {
      #   enable = true;
      # };

      # backup
      windowManager.bspwm.enable = true;

      # TODO FIX THIS !!!!!!
      windowManager.session = let
        # dpi thing ill figure out later
        # extraConfig = pkgs.writeText "emacs-extra-config" ''
        #   (setq mb/system-settings
        #     '((desktop/dpi . ${(toString cfg.dpi)})
        #       (desktop/hidpi . ${
        #     if cfg.hidpi
        #     then "t"
        #     else "nil"
        #   })))
        # '';
        extraConfig = pkgs.writeText "emacs-loadscript" ''
         (setq is-exwm t)
         (exwm-init)
        '';
      in
        lib.singleton {
          name = "exwm";
          # launch emacs in fullscreen with dbus lol
          start = ''
            ${pkgs.dbus.dbus-launch} --exit-with-session emacs -mm \
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
    };

      services.libinput = {
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

    users.users.sako.packages = with pkgs; [
      rofi
      # network
      networkmanagerapplet
      # brightness
      brightnessctl
      # background
      feh
      # gee tee k
      vimix-gtk-themes
      vimix-icon-theme
      lxappearance
      catppuccin-cursors.mochaDark
      # screen shot (s)
      flameshot
      # counsel-linux-apps
      # surely theres a better way right? just need gtk-laucnh
      gtk3
    ];

    # environment.systemPackages = with pkgs; [
    # ];

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
        # backup
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
