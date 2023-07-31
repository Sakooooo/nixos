{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.calibre;
in
{
  options.modules.desktop.apps.calibre = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      calibre
    ];

    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}
