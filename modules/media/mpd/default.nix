{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.media.mpd;
in
{
  options.modules.media.mpd = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
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
