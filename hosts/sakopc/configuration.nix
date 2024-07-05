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
    # TODO:: Add this back once generated!!!!!!!
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
      dunst.enable = true;
      apps = {
        nextcloud.enable = true;
        rssguard.enable = true;
        obs.enable = true;
        pass.enable = true;
        localsend.enable = true;
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
        signal.enable = true;
      };
      game = {
        lutris.enable = true;
        steam.enable = true;
        wine.enable = true;
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
<<<<<<< HEAD
      mpd.enable = true;
      ncmpcpp.enable = true;
      mopidy.enable = true;
=======
      mpd.enable = false;
      ncmpcpp.enable = false;
      mopidy.enable = false;
>>>>>>> 3d81864 (nvm)
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

  # fuck you AOC
  # my monitor only works on 240hz now
  services.xserver.displayManager.setupCommands = ''
  ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --mode 1920x1080 --rate 239.96 --primary --output HDMI-0 --mode 1920x1080 --left-of DP-0
  '';

  # lol
  services.xserver.dpi = 100;

  home-manager.users.sako.home.stateVersion = "24.05";
  # DO NOT CHANGE THIS!!!!
  # ONLY CHANGE WHEN FULLY REINSTALLING
  # OR USING NEW SYSTEMS
  system.stateVersion = "24.05";
}
