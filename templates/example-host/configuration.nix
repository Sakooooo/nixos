{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
}: {
  imports = [
    # Hardware Configuration
    # Probably a better idea to add it into the flake
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "CHANGEME";

  # All the options
  # Change/Add to your liking
  modules = {
    desktop = {
      desktop = {
        # environments
        awesome.enable = false;
        bspwm = {
          enable = false;
          lemonbar.enable = false;
          polybar.enable = false;
        };
        dwm.enable = false;
        # Make sure wayland is off for these two on nvidia
        gnome.enable = false;
        kde.enable = false;
        # EXTREME Caution when using this with nvidia
        hyprland.enable = false;
        xmonad.enable = false;
        # terminals
        kitty.enable = false;
        # compositor
        picom.enable = false;
        # non categorized applications
        apps = {
          calibre.enable = false;
          kcc.enable = false;
          kdeconnect.enable = false;
          keepassxc.enable = false;
          mangal.enable = false;
          nemo.enable = false;
          nicotineplus.enable = false;
          obs.enable = false;
          pass.enable = false;
          transmission.enable = false;
        };

        # browsers for the web :)
        browsers = {
          firefox.enable = false;
          qutebrowser.enable = false;
        };

        # Communication
        chat = {
          discord.enable = false;
        };

        # Time wasters
        game = {
          lutris.enable = false;
          steam.enable = false;
          wine.enable = false;
        };
      };
      # If you love making computers do stuff
      # Or you like feeling like your doing something
      dev = {
        # whats a programmer without an editor?
        editors = {
          nvim.enable = false;
          vscode.enable = false;
        };
        # Languages
        cc.enable = false;
        javascript.enable = false;
        lua.enable = false;
        python.enable = false;
        rust.enable = false;
        unityhub.enable = false;
        # Nix langauge servers (NIXD IS IN BETA!!)
        nixd.enable = false;
        nil.enable = false;
      };
      # the things that make your computer go vroom
      hardware = {
        # OOOOH 5G BRAIN DAMAGE PROBABLY
        bluetooth.enable = false;
        # intel :) (just tools for now)
        intel.enable = false;
        # nvidia :(
        nvidia.enable = false;
        # better than pulseaudio
        pipewire.enable = false;
      };
      # Media :)
      media = {
        # music
        mpd.enable = false;
        # music client
        ncmpcpp.enable = false;
      };

      # good old tty
      shell = {
        # terminal rss
        newsboat.enable = false;
        nix = {
          # Automatically clean nix store
          optimization.enable = false;
          # `nix search nixpkgs <package>`
          search.enable = false;
          # file manager for nerds
          ranger.enable = false;
          # terminal window manager for nerds
          tmux.enable = false;
          # shells
          zsh.enable = false;
        };
      };
    };
  };
}
