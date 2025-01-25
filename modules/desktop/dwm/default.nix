{
  inputs,
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.dwm;
in {
  options.modules.desktop.dwm = {enable = lib.mkEnableOption false;};

  config = lib.mkIf cfg.enable {
    # for flatpak
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.config.common.default = "*";

    programs.dconf.enable = true;

    #   services.displayManager.defaultSession = "dwm";

    services.libinput = {
      enable = true;

      # no mouse accel
      mouse = {accelProfile = "flat";};

      # no touchpad accel
      touchpad = {accelProfile = "flat";};
    };

    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      windowManager.dwm.package = pkgs.dwm.overrideAttrs {
        src = ../../../config/dwm;
      };
      displayManager.lightdm = {
        enable = true;
        greeters.gtk = {enable = true;};
      };
    };

    users.users.sako.packages = with pkgs; [
      rofi
      networkmanagerapplet
      brightnessctl
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
    };
  };
}
