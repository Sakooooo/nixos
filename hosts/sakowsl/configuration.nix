{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    "${modulesPath}/profiles/minimal.nix"
    outputs.nixosModules.desktop
    outputs.nixosModules.shell
    outputs.nixosModules.hardware
    outputs.nixosModules.dev
    outputs.nixosModules.media
    outputs.nixosModules.security
  ];

  wsl = {
    enable = true;
    wslConf = {
      automount = {
        root = "/mnt";
        # Allows writing to linux network section in Explorer
        options = "metadata,uid=1000,gid=100,umask=22,fmask=11";
      };
    };
    defaultUser = "sako";
    startMenuLaunchers = true;

    # Native systemd for wsl
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  users.users.sako.isNormalUser = true;

  networking.hostName = "sakowsl";

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Home manager setup
  home-manager.useUserPackages = true;
  home-manager.users.sako = {pkgs, ...}: {
    home.stateVersion = "22.05";
    home.packages = [];
    home.username = "sako";
    home.homeDirectory = "/home/sako";
    xdg.configFile.git = {
      source = ../../config/git;
    };

    # cure my sanity
    home.pointerCursor = {
      name = "Catppuccin-Mocha-Dark";
      size = 16;
      x11 = {
        enable = true;
      };
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
    };
    gtk = {
      enable = true;
      theme.name = "vimix-dark-ruby";
      iconTheme.name = "Vimix Ruby Dark";
    };
  };

  # gtk themes
  programs.dconf.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = null;
    settings = {
      pinentry-program = "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe";
    };
  };
  # bare minimum
  environment.systemPackages = with pkgs; [
    vim # backup
    wget #double u get
    killall # die processes
    unzip # zip file
    gh # github
    htop # htop
    tree # trees
    wsl-open # wsl-open
  ];

  environment.noXlibs = lib.mkForce false;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  modules = {
    desktop = {
      apps = {
        nextcloud.enable = true;
        pass.enable = true;
      };
    };
    dev = {
      editors = {
        nvim.enable = true;
        emacs = {
          enable = true;
          daemon = false;
          type = "unstable-pgtk";
        };
      };
      cc.enable = true;
      nil.enable = true;
      lua.enable = true;
      python.enable = true;
      rust.enable = true;
      javascript.enable = true;
    };
    shell = {
      zsh.enable = true;
      tmux.enable = true;
      ranger.enable = true;
      nix = {
        optimize.enable = true;
        search.enable = true;
      };
    };
    security = {
      certs.enable = true;
    };
  };

  # for wsl-open
  environment.sessionVariables = rec {
    BROWSER = "wsl-open";
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "22.05";
}
