{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.gnome;
in
{
  options.modules.desktop.gnome = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          # not taking any chances
          wayland = false;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };
    # somethings wrong with gnome i think
    sound.enable = true;
    # gnome extensions
    environment.systemPackages = with pkgs; [ 
      gnomeExtensions.appindicator 
    ];
    # gnome udev settings
    services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon 
    ];
  };
}
