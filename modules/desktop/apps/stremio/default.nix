{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.stremio;
in
{
  options.modules.desktop.apps.stremio = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      stremio
    ];
  };
}
