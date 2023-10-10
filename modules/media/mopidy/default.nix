{
  outputs,
  options,
  config,
  lib,
  pkgs,
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
      extensionPackages = [pkgs.mopidy-mpd pkgs.mopidy-jellyfin];
      configuration = ''
        [jellyfin]
        hostname = https://jellyfin.sako.box
        username = sako
        password =
        libraries = Music
        albumartistsort = False
        album_format = {ProductionYear} - {Name}

        [mpd]
        enabled = true
        host = 127.0.0.1
        connection_timeout = 300
      '';
    };
  };
}
