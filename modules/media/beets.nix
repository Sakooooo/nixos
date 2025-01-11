{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.media.beets;
in {
  options.modules.media.beets = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    home-manager.users.sako = {
      programs.beets = {
        enable = true;
        settings = {
          plugins = [ "fetchart" "embedart" "scrub" "replaygain" "chroma" ];
          directory = "/srv/media/music";
          library = "~/.config/beets/library.db";
          import = {
            write = true;
            move = false;
            copy = true;
            quiet_fallback = "skip";
            log = "~/.config/beets/beets.log";
          };
          paths = {
            default = "$albumartist/$album%aunique{}/$track - $title";
            singleton = "Non-Album/$artist - $title";
            comp = " Compilations/$album%aunique{}/$track - $title";
            albumtype_soundtrack = "Soundtracks/$album/$track $title";
          };
          replaygain.backend = "gstreamer";
          embedart.auto = true;
          fetchart.auto = true;
        };
      };
    };
  };
}
