# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # required for hostname specific configurations
  networking.hostName = "sakovm"; # Define your hostname.

  modules = {
    desktop = {
      kitty.enable = true;
      dwm.enable = true;
      xmonad.enable = false;
      picom.enable = true;
      dunst.enable = true;
      browsers = {
        firefox.enable = true;
        qutebrowser.enable = false;
        chromium.enable = true;
      };
      chat = {
        whatsapp.enable = true;
        zoom.enable = true;
      };
      apps = {
        nemo.enable = true;
        pass.enable = true;
        keepassxc.enable = true;
        rssguard.enable = true;
        nicotineplus.enable = true;
        transmission.enable = true;
        calibre.enable = true;
        kindle-comic-converter.enable = true;
        mangal.enable = true;
        obs.enable = true;
        nextcloud.enable = true;
      };
      game = {
        wine.enable = true;
        lutris.enable = true;
        steam.enable = true;
        grapejuice.enable = true;
      };
      media = {
        gimp.enable = true;
        blender.enable = true;
        kdenlive.enable = true;
        mpv.enable = true;
      };
    };
    hardware = {
      pipewire.enable = true;
    };
    dev = {
      editors = {
        nvim.enable = true;
        emacs.enable = true;
      };
      nil.enable = true;
      cc.enable = true;
      javascript.enable = true;
      python.enable = true;
      rust.enable = true;
      lua.enable = true;
    };
    shell = {
      nix = {
        # makes nix search nixpkgs <example>
        # ALOT faster
        search.enable = true;
        # optimize store
        optimize.enable = true;
      };
      zsh.enable = true;
      tmux.enable = true;
      newsboat.enable = true;
      ranger.enable = true;
    };
    media = {
      mpd.enable = true;
      ncmpcpp.enable = true;
    };
    work = {
      libreoffice.enable = true;
      onlyoffice.enable = true;
    };
    security = {
      age.enable = true;
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
