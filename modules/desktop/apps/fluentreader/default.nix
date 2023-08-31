{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.fluentreader;
in
{
  options.modules.desktop.apps.fluentreader = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      fluent-reader 
    ];
  };
}
