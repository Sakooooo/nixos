{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.media.jellyfin;
in {
  options.modules.desktop.media.jellyfin = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      jellyfin-media-player
    ];
  };
}
