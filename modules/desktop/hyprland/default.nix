{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      nvidiaPatches = true;
      xwayland = true;
    }; 
  };
}
