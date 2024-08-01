{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.wezterm;
in {
  options.modules.desktop.wezterm = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      wezterm
    ];

    home-manager.users.sako = {...}: {
      home.file.".wezterm.lua" = {
        enable = true;
        source = ../../../config/wezterm/wezterm.lua;
      };
    };
  };
}
