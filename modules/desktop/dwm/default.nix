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

#   services.displayManager.defaultSession = "dwm";
    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      windowManager.dwm.package = pkgs.dwm.overrideAttrs {
        src = ./dwm;
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
  };
}
