{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.media.kdenlive;
in {
  options.modules.desktop.media.kdenlive = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      kdePackages.kdenlive
      mediainfo
      glaxnimate
    ];
  };
}
