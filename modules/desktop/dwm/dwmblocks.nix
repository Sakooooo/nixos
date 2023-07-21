{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.dwm.dwmblocks;
in
{
  options.modules.desktop.dwm.dwmblocks = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      dwmblocks
    ];
    pkgs.dwmblocks.configfile = ../../../config/dwmblocks/blocks.def.h;
  };
}
