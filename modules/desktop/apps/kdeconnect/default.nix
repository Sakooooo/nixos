{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.kdeconnect;
in
{
  options.modules.desktop.apps.kdeconnect = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    #users.users.sako.packages = with pkgs; [
    #  kdeconnect
    #];
    programs.kdeconnect.enable = true;
    networking.firewall = {
      allowedTCPPortRanges = [ 
       { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
       { from = 1714; to = 1764; } # KDE Connect
      ];
    };
  };
}
