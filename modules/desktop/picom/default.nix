{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.picom;
in
{
  options.modules.desktop.picom = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      picom
    ];
    home-manager.users.sako = { pkgs, ...}: {
      xdg.configFile = {
        picom = {
          source = ../../../config/picom;
          recursive = true;
        };
      };
    };
  };
}
