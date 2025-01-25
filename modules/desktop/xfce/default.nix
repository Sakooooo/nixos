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

    services.displayManager.defaultSession = "xfce";
    services.xserver = {
      enable = true;
      desktopManager = {
        xfce.enable = true;
      };
    };
  };
}
