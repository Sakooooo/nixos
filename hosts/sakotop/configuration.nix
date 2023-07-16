# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../default.nix
    ];

  # required for hostname specific configurations
  networking.hostName = "sakotop"; # Define your hostname.

  modules = {
    desktop = {
      kitty.enable = true;
      bspwm = {
        enable = true;
        polybar.enable = true;
      };
      dunst.enable = true;
      browsers = {
        qutebrowser.enable = true;
        # for those quick thinsg where i dont know how to do it on qutebrowser
        firefox.enable = true;
      };
      apps = {
        nemo.enable = true;
        keepassxc.enable = true;
        nicotineplus.enable = true;
      };
      chat = {
        discord.enable = true;
      };
      game = {
        wine.enable = true;
        lutris.enable = true;
        steam.enable = true;
      };
      media = {
        gimp.enable = true;
        # this is broken
        resolve.enable = true;
        blender.enable = true;
        kdenlive.enable = true;
        lmms.enable = true;
      };
    };
    hardware = {
      nvidia.enable = true;
      pipewire.enable = true;
      bluetooth.enable = true;
    };
    dev = {
      editors = {
        nvim.enable = true;
      };
      cc.enable = true;
      javascript.enable = true;
      python.enable = true;
      rust.enable = true;
      unity.enable = true;
      projects = {
        sakoEngine.enable = true;
      };
    };
    shell = {
      nix = {
        # makes nix search nixpkgs <example>
        # ALOT faster
        search.enable = true;
      };
      zsh.enable = true;
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
  users.users.sako= {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      newsboat
    ];
  };

    services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # garbage collection
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}

