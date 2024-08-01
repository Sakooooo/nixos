{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.gnome;
in
{
  options.modules.desktop.gnome = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
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
