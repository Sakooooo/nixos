{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.picom;
in {
  options.modules.desktop.picom = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      picom
    ];
    home-manager.users.sako = {pkgs, ...}: {
      xdg.configFile = {
        picom = {
          source = ../../../config/picom;
          recursive = true;
        };
      };
    };
  };
}
