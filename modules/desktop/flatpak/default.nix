{ inputs, outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.flatpak;
in {
  options.modules.desktop.flatpak = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # todo enable xdg portal when NOT hyprland
    # todo declarative thingies
    services.flatpak.enable = true;
  };
}
