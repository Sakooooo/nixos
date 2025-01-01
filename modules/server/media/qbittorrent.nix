{ config, lib, pkgs, ... }:
with lib;
let cfg = config.void.server.media.qbittorrent;
in {
  options.void.server.media.qbittorrent = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { };
}
