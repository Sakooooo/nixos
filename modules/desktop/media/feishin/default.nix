{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.feishin;
in
{
  options.modules.desktop.media.feishin = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      feishin
    ];
  };
}
