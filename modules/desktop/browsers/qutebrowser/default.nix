{ options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.browsers.qutebrowser;
in
{
  options.modules.desktop.browsers.qutebrowser = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      qutebrowser
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
