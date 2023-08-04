{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.dunst;
in
{
  options.modules.desktop.dunst = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
    ];
  };
}
