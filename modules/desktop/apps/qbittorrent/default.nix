{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.qbittorrent;
in
{
  options.modules.desktop.apps.qbittorrent = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      qbittorrent
    ];
  };
}
