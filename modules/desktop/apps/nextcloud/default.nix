{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.nextcloud;
in
{
  options.modules.desktop.apps.nextcloud = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nextcloud-client
    ];

  };
}
