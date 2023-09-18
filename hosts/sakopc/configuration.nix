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
      dwm.enable = true;
      kitty.enable = true;
      picom.enable = true;
      apps = {
        keepassxc.enable = true;
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
      };
      game = {
        lutris.enable = true;
        steam.enable = true;
        wine.enable = true;
        grapejuice.enable = true;
      };
      media = {
        mpv.enable = true;
        kdenlive.enable = true;
      };
    };
    dev = {
      editors = {
        nvim.enable = true;
        vscode.enable = true;
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
        optimization.enable = true;
        search.enable = true;
      };
      zsh.enable = true;
      tmux.enable = true;
      ranger.enable = true;
    };
    work = {
      libreoffice.enable = true;
    };
  };
}
