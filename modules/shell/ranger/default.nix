{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.ranger;
in {
  options.modules.shell.ranger = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      ranger
      # pdf viewer
      okular
    ];

    home-manager.users.sako = {pkgs, ...}: {
      xdg.configFile = {
        ranger = {
          source = ../../../config/ranger;
          recursive = true;
        };
      };
    };
  };
}
