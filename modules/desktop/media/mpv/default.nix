{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.mpv;
in
{
  options.modules.desktop.media.mpv = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      mpv
    ];

    home-manager.users.sako = { pkgs, ... }: {
      xdg.configFile = {
        mpv = {
          source = ../../../../config/mpv;
          recursive = true;
        };
      };
    };
  };
}
