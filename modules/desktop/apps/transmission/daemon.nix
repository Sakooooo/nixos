{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.transmission;
in
{
  options.modules.desktop.apps.transmission = {
    daemon = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.daemon {
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
