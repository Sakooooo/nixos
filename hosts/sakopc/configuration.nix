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
      flatpak.enable = true;
      wireguard.enable = true;
      printing.enable = true;
      # xfce.enable = true;
      dwm.enable = true;
      # bspwm = {
      #   enable = false;
      #   polybar.enable = false;
      # };
      # hyprland.enable = true;
      # foot.enable = true;
      kitty.enable = true;
      # picom.enable = false;
      # dunst.enable = false;
      apps = {
        nextcloud.enable = true;
        #rssguard.enable = true;
        obs.enable = true;
        pass.enable = true;
        localsend.enable = true;
        nemo.enable = true;
        anki.enable = true;
      };
      browsers = {
        firefox.enable = true;
        qutebrowser.enable = false;
        chromium.enable = false;
      };
      chat = {
        zoom.enable = true;
        discord.enable = true;
        mumble.enable = true;
        thunderbird.enable = true;
        teams.enable = true;
        telegram.enable = true;
        weechat.enable = true;
        signal.enable = true;
        element.enable = true;
        gajim.enable = true;
        psi-plus.enable = true;
      };
      game = {
        #lutris.enable = true;
        steam.enable = false;
        wine.enable = true;
        tetrio.enable = true;
        prismlauncher.enable = true;
      };
      media = {
        mpv.enable = true;
        #ardour.enable = true;
        kdenlive.enable = true;
        blender.enable = true;
        # feishin.enable = true;
        jellyfin.enable = false;
      };
    };
    dev = {
      editors = {
        nvim.enable = true;
        emacs = {
          enable = true;
          daemon = true;
          package = pkgs.emacs-unstable;
        };
        #vscode.enable = true;
      };
      nixd.enable = true;
    };
    hardware = {
      bluetooth.enable = false;
      nvidia.enable = true;
      pipewire.enable = true;
    };
    media = {
      mpd.enable = false;
      ncmpcpp.enable = false;
      mopidy.enable = false;
    };
    shell = {
      nix = {
        optimize.enable = true;
        search.enable = true;
        switch-to-configuration-ng.enable = true;
        nh.enable = true;
        tree.enable = true;
      };
      zsh.enable = true;
      tmux.enable = true;
      ranger.enable = true;
    };
    work = {onlyoffice.enable = true;};
    security = {
      certs.enable = true;
      tor.enable = true;
    };
  };

  # fuck you AOC
  # my monitor only works on 240hz now
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --mode 1920x1080 --rate 239.96 --primary --output HDMI-0 --mode 1920x1080 --left-of DP-0
  '';

  # secrets
  age.identityPaths = ["/home/sako/.ssh/id_ed25519"];

  age.secrets.test.file = ../../secrets/test.age;

  # lol
  services.xserver.dpi = 100;

  home-manager.users.sako.home.stateVersion = "24.05";
  # DO NOT CHANGE THIS!!!!
  # ONLY CHANGE WHEN FULLY REINSTALLING
  # OR USING NEW SYSTEMS
  system.stateVersion = "24.05";
}
