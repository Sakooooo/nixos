{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.ardour;
in
{
  options.modules.desktop.media.ardour = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      ardour
    ];
  };
}
