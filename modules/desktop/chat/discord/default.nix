{ outputs, options, config, lib, pkgs, ... }:
let
  cfg = config.modules.desktop.chat.discord;
  hyprland = config.modules.desktop.hyprland;
in {
  options.modules.desktop.chat.discord = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = [ pkgs.vesktop ];

  };
}
