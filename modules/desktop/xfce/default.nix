{
  inputs,
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.xfce;
in {
  options.modules.desktop.xfce = {enable = lib.mkEnableOption false;};

  config = lib.mkIf cfg.enable {
    modules.desktop.dunst.enable = lib.mkForce false;

    # for flatpak
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    # things
    services.gnome.gnome-keyring.enable = true;

    services.displayManager.defaultSession = "xfce";
    services.xserver = {
      enable = true;
      desktopManager = {xfce.enable = true;};
      displayManager.lightdm = {
        enable = true;
        greeters.gtk = {enable = true;};
      };
    };

    home-manager.users.sako = {pkgs, ...}: {
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
      };
    };
  };
}
