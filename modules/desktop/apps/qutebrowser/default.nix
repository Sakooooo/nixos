{ options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.apps.qutebrowser;
in
{
  options.modules.desktop.apps.qutebrowser = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      qutebrowser-qt6
      python310Packages.pynacl
      python310Packages.adblock
    ];

    home-manager.users.sako = { pkgs , ...}: {
    xdg.configFile = {
      "qutebrowser/config.py" = {
        source = ../../../../config/qutebrowser/config.py;
        };
      "qutebrowser/greasemonkey" = {
        source = ../../../../config/qutebrowser/greasemonkey;
        recursive = true;
      };
      }; 
    };
  };
}
