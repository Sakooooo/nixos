{ options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.foot;
in {
  options.modules.desktop.foot = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {

  users.users.sako.packages = with pkgs; [
    foot
  ];

  home-manager.users.sako = {pkgs, ...}: {
    xdg.configFile = {
      foot = {
        source = ../../../config/foot;
      };
    };
  };
  };
}
