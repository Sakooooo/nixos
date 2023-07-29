{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.transmission.tui;
in
{
  options.modules.desktop.apps.transmission= {
    tui = mkEnableOption false;
  };

  config = mkIf cfg {
    users.users.sako.packages = with pkgs; [
      stig
    ];
  };
}
