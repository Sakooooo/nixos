# ITS A FILE SHARING THING
# NOT A GOD DAMN ADDICTION
# IM NOT ADDICTED TO MUSIC
# I SWEAR
{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.nicotineplus;
in
{
  options.modules.desktop.apps.nicotineplus = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nicotine-plus
    ];
  };
}
