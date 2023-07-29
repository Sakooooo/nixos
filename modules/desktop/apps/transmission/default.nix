{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.transmission;
in
{
  imports = [
    ./remote-tui.nix
  ];
  options.modules.desktop.apps.transmission = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
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
