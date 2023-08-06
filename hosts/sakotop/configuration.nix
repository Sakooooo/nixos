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
  networking.hostName = "sakotop"; # Define your hostname.

  modules = {
    desktop = {
      kitty.enable = true;
      xmonad.enable = false;
      awesome.enable = true;
      dwm.enable = false;
      picom.enable = false;
      gnome.enable = false;
      dunst.enable = true;
      browsers = {
        qutebrowser.enable = true;
        firefox.enable = true;
      };
      apps = {
        nemo.enable = true;
        keepassxc.enable = true;
        nicotineplus.enable = true;
        transmission.enable = true;
        calibre.enable = true;
        kindle-comic-converter.enable = true;
        mangal.enable = true;
        obs.enable = true;
      };
      chat = {
        discord.enable = true;
        weechat.enable = true;
      };
      game = {
        wine.enable = true;
        lutris.enable = true;
        steam.enable = true;
      };
      media = {
        gimp.enable = true;
        blender.enable = true;
        mpv.enable = true;
      };
    };
    hardware = {
      nvidia.enable = true;
      intelgputools.enable = true;
      pipewire.enable = true;
      bluetooth.enable = true;
    };
    dev = {
      editors = {
        nvim.enable = true;
        vscode.fhs.enable = true;
      };
      nixd.enable = true;
      nil.enable = false;
      cc.enable = true;
      javascript.enable = true;
      python.enable = true;
      rust.enable = true;
      lua.enable = true;
      # too heavy
      unity.enable = false;
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
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # TODO(sako):: put this in different files
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sako = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  services.xserver.videoDrivers = ["nvidia"];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
