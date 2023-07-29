{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.transmission;
in
{
  options.modules.desktop.apps.transmission = {
    daemon = mkEnableOption false;
  };

  config = mkIf cfg.daemon {
    #TODO(sako):: figure out service
    users.users.sako.packages = with pkgs; [
      transmission
    ];

    home-manager.users.sako = { pkgs, ...}: {
      xdg.configFile = {
        transmission-daemon = {
          source = ../../../../config/transmission-daemon;
          recursive = true;
        };
      };
    };

  };
}
