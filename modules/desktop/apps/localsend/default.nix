{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.localsend;
in
{
  options.modules.desktop.apps.localsend = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      localsend
    ];
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [];
    };
  };
}
