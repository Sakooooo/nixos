{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.transmission.tui;
in
{
  options.modules.desktop.apps.transmission= {
    tui = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg {
    users.users.sako.packages = with pkgs; [
      stig
    ];
  };
}
