{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.dunst;
in
{
  options.modules.desktop.dunst = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
      libnotify
    ];
  };
}
