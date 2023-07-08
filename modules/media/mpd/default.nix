{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.media.mpd;
in
{
  options.modules.media.mpd = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      user = "sako";
      musicDirectory = "/home/sako/music";
      extraConfig = builtins.readFile ../../../config/mpd/mpd.conf;
      startWhenNeeded = true;
    };
    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
