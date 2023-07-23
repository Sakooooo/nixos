{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.xmonad;
in
{
  options.modules.desktop.xmonad = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
  # https://nixos.wiki/wiki/XMonad
    services.xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
         ghcArgs = [
              "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
              "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
#              "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
         ];
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../../config/background.png;
          greeters.gtk = {
            enable = true;
            theme = {
              name = "vimix-dark-ruby";
              package = pkgs.vimix-gtk-themes;
            };
          };
        };
      };
      libinput = {
        enable = true;

        # mouse
        mouse = {
          accelProfile = "flat";
        };

        # touchpad 
        touchpad = {
          accelProfile = "flat";
        };
      };
    };

    users.users.sako.packages = with pkgs; [
      rofi
      # network
      networkmanagerapplet
      # brightness
      brightnessctl
      # gee tee k
      vimix-gtk-themes
      vimix-icon-theme
      lxappearance
      catppuccin-cursors.mochaDark
      # screen shot (s)
      flameshot
    ];

    environment.systemPackages = with pkgs; [
      # bar
      xmobar
      # tray
      trayer
    ];

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
        xmonad = {
          source = ../../../config/xmonad;
          recursive = true;
        };
        xmobar = {
          source = ../../../config/xmobar;
          recursive = true;
        };
     }; 
    };
    };
}
