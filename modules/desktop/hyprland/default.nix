{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
#        lightdm = {
#          enable = true;
#          background = ../../../config/background.png;
#          greeters.gtk = {
#            enable = true;
#            theme = {
#              name = "vimix-dark-ruby";
#              package = pkgs.vimix-gtk-themes;
#            };
#          };
#        };
        gdm = {
          enable = true;
        };
      };
      libinput = {
        enable = true;

        # no mouse accel
        mouse = {
          accelProfile = "flat";
        };

        # no touchpad accel
        touchpad = {
          accelProfile = "flat";
        };
      }; 
    };

    users.users.sako.packages = with pkgs; [
      # use wayland counterparts
      wofi
      # network
      networkmanagerapplet
      # brightness
      # TODO(sako):: find one for wayland
      # gtk
      vimix-gtk-themes
      vimix-icon-theme
      lxappearance
      catppuccin-cursors.mochaDark
      # screenshot
      grim
      flameshot
      # todo figure this out
      gamescope
    ];
    environment.systemPackages = with pkgs; [
      # bg
      hyprpaper
      # bar
      (waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true "]; }))
      brightnessctl
      inotify-tools
    ];

    programs.hyprland = {
      enable = true;
      nvidiaPatches = true;
    }; 
    home-manager.users.sako = { pkgs , ...}: {
      home.pointerCursor = {
        name = "Catppuccin-Mocha-Dark"; 
        size = 16;
        x11 = {
          enable = true;
        };
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
      };
      gtk = {
        enable = true;
        theme.name = "vimix-dark-ruby";
        iconTheme.name = "Vimix Ruby Dark";
      };
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
      };
      xdg.configFile = {
        hypr = {
          source = ../../../config/hyprland; 
          recursive = true;
        };
        waybar = {
          source = ../../../config/waybar;
          recursive = true;
        };
     }; 
    };
  };
}
