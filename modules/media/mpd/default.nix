{ config, pkgs, lib, ...}:
with lib;
let cfg = config.modules.media.mpd;
in {
  options.modules.media.mpd = {
    enable = mkOption {
     type = types.bool;
     default = false;
    };
  };
  config = mkIf cfg.enable {
  services.mpd = {
    enable = true;
    # pipewire fix
    user = "sako";
    musicDirectory = "/home/sako/music";
    extraConfig = builtins.readFile ../../../config/mpd/mpd.conf;
    startWhenNeeded = true;
  };

  # systemd fix pipewire
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
  };

}
