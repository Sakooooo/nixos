{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.web.qutebrowser;
in {
  options.modules.web.qutebrowser = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako = {
      packages = with pkgs; [
        qutebrowser-qt6
        python310Packages.pynacl
        python310Packages.adblock
      ];
    };
    
    nixpkgs.overlays = [
      (final: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
    ];
    xdg.configFile = {
      "qutebrowser/config.py" = {
        source = ../../../config/qutebrowser/config.py;
      };
      "qutebrowser/greasemonkey" = {
        source = ../../../config/qutebrowser/greasemonkey;
        recursive = true;
      };
    };
  };
}
