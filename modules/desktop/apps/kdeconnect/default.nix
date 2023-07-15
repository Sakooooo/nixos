{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.kdeconnect;
in
{
  options.modules.desktop.apps.kdeconnect = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    #users.users.sako.packages = with pkgs; [
    #  kdeconnect
    #];
    programs.kdeconnect.enable = true;
    networking.fireall = {
      allowedTCPPortRanges = [ 
       { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
       { from = 1714; to = 1764; } # KDE Connect
      ];
    };
  };
}
