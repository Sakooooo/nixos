{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.ranger;
in {
  options.modules.shell.ranger = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
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
