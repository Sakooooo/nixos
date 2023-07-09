{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.kde;
in
{
  options.modules.desktop.kde = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      libinput.enable = true;
      desktopManager.plasma5.enable = true;
    }; 
  };
}
