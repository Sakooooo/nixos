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
      wireguard.enable = true;
      tailscale.enable = true;
      kitty.enable = true;
      flatpak.enable = true;
      hyprland.enable = true;
      browsers = {
        firefox.enable = true;
        qutebrowser.enable = false;
        chromium.enable = true;
      };
      chat = {
        zoom.enable = true;
        discord.enable = true;
        signal.enable = true;
        teams.enable = true;
        telegram.enable = true;
        weechat.enable = true;
        element.enable = true;
        gajim.enable = true;
        psi-plus.enable = true;
      };
      apps = {
        nemo.enable = true;
        pass.enable = true;
        rssguard.enable = true;
        nicotineplus.enable = true;
        transmission.enable = false;
        qbittorrent.enable = true;
        obs.enable = true;
        nextcloud.enable = true;
        localsend.enable = true;
        anki.enable = true;
      };
      game = {
        wine.enable = true;
        lutris.enable = true;
        steam.enable = true;
        tetrio.enable = true;
        osu.enable = true;
        prismlauncher.enable = true;
      };
      media = {
        gimp.enable = true;
        # feishin.enable = true;
        blender.enable = true;
        kdenlive.enable = true;
        resolve.enable = false;
        mpv.enable = true;
        jellyfin.enable = true;
      };
      security = {wireshark.enable = true;};
    };
    hardware = {
      nvidia = {
        enable = true;
        prime = {
          enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      intelgputools.enable = true;
      pipewire.enable = true;
      bluetooth.enable = true;
    };
    dev = {
      editors = {
        nvim.enable = true;
        emacs = {
          enable = true;
          daemon = true;
          package = pkgs.emacs-unstable-pgtk;
        };
        # backup/just cause
        vscode.enable = true;
      };
      nixd.enable = true;
      # cc.enable = true;
      # csharp.enable = true;
      # javascript.enable = true;
      # python.enable = true;
      # rust.enable = true;
      # lua.enable = true;
    };
    shell = {
      nix = {
        # makes nix search nixpkgs <example>
        # ALOT faster
        search.enable = true;
        # optimize store
        optimize.enable = true;
        switch-to-configuration-ng.enable = true;
        # better cli
        nh.enable = true;
        # tree
        tree.enable = true;
      };
      zsh.enable = true;
      tmux.enable = true;
      newsboat.enable = true;
      ranger.enable = true;
      aria.enable = true;
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
      certs.enable = true;
      tor.enable = true;
    };
    virtualization = {waydroid.enable = true;};
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  networking.wireguard.interfaces = {};

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # set laptop dpi
  services.xserver.dpi = 100;

  age.identityPaths = ["/home/sako/.ssh/id_ed25519"];

  age.secrets.test.file = ../../secrets/test.age;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # DO NOT CHANGE THIS!!!!
  # ONLY CHANGE WHEN FULLY REINSTALLING
  # OR USING NEW SYSTEMS
  home-manager.users.sako.home.stateVersion = "23.05";

  system.stateVersion = "23.05";
}
