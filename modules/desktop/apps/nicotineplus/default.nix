{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.nicotineplus;
in
{
  options.modules.desktop.apps.nicotineplus = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nicotine-plus
    ];
  };
}
