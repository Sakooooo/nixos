{ inputs, outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.hyprland;
in {
  imports = [ inputs.hyprland.nixosModules.default ];

  options.modules.desktop.hyprland = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {

    modules.desktop.dunst.enable = lib.mkForce false;

    services.gnome.gnome-keyring.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        terminal = { vt = 2; };
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
    # make greetd not have systemd logs overlap
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    services.xserver = {
      enable = true;
      # displayManager = {
      # #        lightdm = {
      # #          enable = true;
      # #          background = ../../../config/background.png;
      # #          greeters.gtk = {
      # #            enable = true;
      # #            theme = {
      # #              name = "vimix-dark-ruby";
      # #              package = pkgs.vimix-gtk-themes;
      # #            };
      # #          };
      # #        };
      #  gdm = {
      #    enable = true;
      #  };
      # };
    };
    services.libinput = {
      enable = true;

      # no mouse accel
      mouse = { accelProfile = "flat"; };

      # no touchpad accel
      touchpad = { accelProfile = "flat"; };
    };

    users.users.sako.packages = with pkgs; [
      # use wayland counterparts
      wofi
      rofi-wayland
      # network
      networkmanagerapplet
      # brightness
      # TODO(sako):: find one for wayland
      catppuccin-cursors.mochaDark
      # screenshot
      sway-contrib.grimshot
      # todo figure this out
      gamescope
      # playerctl
      playerctl
    ];
    environment.systemPackages = with pkgs; [
      # bg
      inputs.hyprpaper.packages.${pkgs.system}.default
      # bar
      waybar
      # lock
      # swaylock
      inputs.ags.packages.${pkgs.system}.default
      brightnessctl
      inotify-tools
      greetd.tuigreet
      # notifications
      mako
      # cursor
      catppuccin-cursors.mochaDark
      # gtk
      fluent-gtk-theme
      fluent-icon-theme
      # clipboard
      wl-clipboard
    ];

    programs.hyprland = { enable = true; };

    programs.hyprlock.enable = true;

    # ags battery
    services.upower.enable = true;

    # piece of shit thanks!
    services.emacs.startWithGraphical = false;

    home-manager.users.sako = { pkgs, ... }: {
      home.pointerCursor = {
        # name = "Catppuccin-Mocha-Dark"; 
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
      };
      gtk = {
        enable = true;
        theme.name = "Fluent-pink-Dark";
        iconTheme.name = "Fluent-pink-dark";
      };
      home.file = {
        "background.png" = {
          enable = true;
          source = ../../../config/background.png;
        };
        # this automatically sets the types
        # thanks PartyWumpus
        # https://github.com/PartyWumpus/dotfiles/blob/277949d84d53a58a3f52be935cd3c581c89d5d7c/modules/hyprland/hyprland.nix#L492
        "/nixos/config/ags/types" = {
          source =
            "${inputs.ags.packages.x86_64-linux.agsWithTypes.out}/share/com.github.Aylur.ags/types";
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
        # swaylock = {
        #   source = ../../../config/swaylock;
        #   recursive = true;
        # };
        ags = {
          source = ../../../config/ags;
          recursive = true;
        };
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # swaylock doesnt work without this
    # security.pam.services.swaylock.text = ''
    #   # PAM configuration file for the swaylock screen locker. By default, it includes
    #   # the 'login' configuration file (see /etc/pam.d/login)
    #   auth include login
    # '';

  };
}
