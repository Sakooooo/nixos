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
      '';
    };
  };
}
