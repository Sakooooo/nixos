{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.lmms;
in
{
  options.modules.desktop.media.lmms = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      lmms
    ];
  };
}
