{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Hardware Configuration
    # Probably a better idea to add it into the flake
    ./hardware-configuration.nix
  ];

  # hostname
  networking.hostName = "sakopc";

  modules = {
    desktop = {
      bspwm = {
        enable = true;
        polybar.enable = true;
      };
      kitty.enable = true;
      picom.enable = true;
      apps = {
        keepassxc.enable = true;
        nextcloud.enable = true;
        rssguard.enable = true;
        bitwarden.enable = true;
        obs.enable = true;
      };
      browsers = {
        firefox.enable = true;
        qutebrowser.enable = false;
        chromium.enable = true;
      };
      chat = {
        whatsapp.enable = true;
        zoom.enable = true;
        discord.enable = true;
        teams.enable = true;
        telegram.enable = true;
        weechat.enable = true;
      };
      game = {
        lutris.enable = true;
        steam.enable = true;
        wine.enable = true;
        grapejuice.enable = true;
        tetrio.enable = true;
      };
      media = {
        mpv.enable = true;
        kdenlive.enable = true;
        blender.enable = true;
      };
    };
    dev = {
      editors = {
        nvim.enable = true;
        emacs = {
          enable = true;
          daemon = true;
        };
      };
      cc.enable = true;
      javascript.enable = true;
      lua.enable = true;
      python.enable = true;
      rust.enable = true;
      nil.enable = true;
    };
    hardware = {
      bluetooth.enable = false;
      nvidia.enable = true;
      pipewire.enable = true;
    };
    media = {
      mpd.enable = true;
      ncmpcpp.enable = true;
    };
    shell = {
      nix = {
        optimize.enable = true;
        search.enable = true;
      };
      zsh.enable = true;
      tmux.enable = true;
      ranger.enable = true;
    };
    work = {
      libreoffice.enable = true;
      onlyoffice.enable = true;
    };
    security = {
      sops.enable = true;
      certs.enable = true;
    };
  };

  home-manager.users.sako.home.stateVersion = "23.11";
  # DO NOT CHANGE THIS!!!!
  # ONLY CHANGE WHEN FULLY REINSTALLING
  # OR USING NEW SYSTEMS
  system.stateVersion = "23.11";
}
