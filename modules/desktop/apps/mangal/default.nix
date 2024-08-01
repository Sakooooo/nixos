{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.mangal;
in
{
  options.modules.desktop.apps.mangal = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      mangal
    ];
  };
}
