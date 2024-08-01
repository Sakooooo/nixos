{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.kde;
in
{
  options.modules.desktop.kde = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      libinput.enable = true;
      desktopManager.plasma5.enable = true;
    }; 
  };
}
