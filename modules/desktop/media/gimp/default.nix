{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.gimp;
in
{
  options.modules.desktop.media.gimp = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      gimp
    ];
  };
}
