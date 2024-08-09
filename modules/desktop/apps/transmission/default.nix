{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.transmission;
in
{
  imports = [
    ./remote-tui.nix
    ./daemon.nix
  ];
  options.modules.desktop.apps.transmission = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    #TODO(sako):: figure out service
    users.users.sako.packages = with pkgs; [
      transmission_4-gtk
    ];
  };
}
