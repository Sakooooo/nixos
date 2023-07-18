{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.media.mpv;
in
{
  options.modules.desktop.media.mpv = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
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
