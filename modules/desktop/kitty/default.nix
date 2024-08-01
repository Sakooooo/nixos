{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.kitty;
in {
  options.modules.desktop.kitty = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      kitty
    ];

    home-manager.users.sako = {pkgs, ...}: {
      xdg.configFile = {
        kitty = {
          source = ../../../config/kitty;
        };
      };
    };

    # also just in case
    fonts.packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };
}
