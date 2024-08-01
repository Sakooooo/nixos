{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.kindle-comic-converter;
in
{
  options.modules.desktop.apps.kindle-comic-converter = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      kcc
    ];
  };
}
