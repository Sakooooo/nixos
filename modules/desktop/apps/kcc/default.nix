{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.kindle-comic-converter;
in
{
  options.modules.desktop.apps.kindle-comic-converter = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      kcc
    ];
  };
}
