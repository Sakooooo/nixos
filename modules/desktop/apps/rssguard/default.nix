{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.rssguard;
in
{
  options.modules.desktop.apps.rssguard = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      rssguard
    ];
  };
}
