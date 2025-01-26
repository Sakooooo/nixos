{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    # this is needed for gtk configuration to work
    programs.dconf.enable = true;

    # keyring
    services.gnome.gnome-keyring.enable = true;

    # flatpak
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

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
          greeters.gtk.enable = true;
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
        # name = "Catppuccin-Mocha-Dark";
        name = "BreezeX-RosePine-Linux";
        size = 24;
        gtk.enable = true;
        package = pkgs.rose-pine-cursor;
      };
      gtk = {
        enable = true;
        theme.name = "Fluent-pink-Dark";
        theme.package = pkgs.fluent-gtk-theme.override {
          colorVariants = ["dark"];
          themeVariants = ["pink"];
          tweaks = ["square"];
        };
        iconTheme.name = "Fluent-pink-dark";
        iconTheme.package = pkgs.fluent-icon-theme.override {colorVariants = ["pink"];};
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
