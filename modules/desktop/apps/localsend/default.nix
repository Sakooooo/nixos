{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.localsend;
in
{
  options.modules.desktop.apps.localsend = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      localsend
    ];
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [];
    };
  };
}
