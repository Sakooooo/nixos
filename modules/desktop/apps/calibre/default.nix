{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.calibre;
in
{
  options.modules.desktop.apps.calibre = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      calibre
    ];
  };
}
