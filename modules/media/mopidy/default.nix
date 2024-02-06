{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.media.mopidy;
in {
  options.modules.media.mopidy = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.mopidy = {
      enable = true;
      extensionPackages = with pkgs; [
        mopidy-jellyfin
        mopidy-mpd
      ];
      configuration = ''
        [core]
        max_tracklist_length = 10000
        restore_state = false

        [audio]
        mixer = software
        mixer_volume =
        output = autoaudiosink
        buffer_time =

        [jellyfin]
        hostname = https://jellyfin.sako.box
        username = sako
        password = sako
        libraries = Music
        albumartistsort = False
        album_format = {ProductionYear} - {Name}

        [mpd]
        enabled = True
        hostname = 127.0.0.1
        port = 6600
        connection_timeout = 300
      '';
    };
  };
}
