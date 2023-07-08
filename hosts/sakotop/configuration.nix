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
      bspwm.enable = true;
      browsers = {
        qutebrowser.enable = true;
      };
      apps = {
        keepassxc.enable = true;
      };
    };
    hardware = {
      nvidia.enable = true;
      pipewire.enable = true;
      bluetooth.enable = true;
    };
    shell = {
      nix = {
        # makes nix search nixpkgs <example>
        # ALOT faster
        search.enable = true;
      };
      zsh.enable = true;
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
      tree
      steam
      winetricks
      wineWowPackages.staging
      lutris
      discord
      networkmanagerapplet
      gcc
      python3
      python310Packages.pip
      rustup
      cargo
      nodejs
      yarn
      newsboat
      ncmpcpp
    ];
  };

# mpd
  services.mpd = {
    enable = true;
    # pipewire fix
    user = "sako";
    musicDirectory = "/home/sako/music";
    extraConfig = builtins.readFile ../../config/mpd/mpd.conf;
    startWhenNeeded = true;
  };

  # systemd fix pipewire
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # garbage collection
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
  };


  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ...}: {
  xdg.configFile = {
	    nvim = {
	        source = ../../config/nvim;
		      recursive = true;
	    };
      ncmpcpp = {
          source = ../../config/ncmpcpp;
          recursive = true;
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}

