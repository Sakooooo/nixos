{
  config,
  inputs,
  outputs,
  pkgs,
  lib,
  home-manager,
  ...
}: {
  imports = [
    # home manager
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
    # TODO:: GET RID OF THIS PLEASE
    # my modules modules
    # import for each folder
    # add entry to module category's default.nix
    outputs.nixosModules.desktop
    outputs.nixosModules.shell
    outputs.nixosModules.hardware
    outputs.nixosModules.dev
    outputs.nixosModules.media
    outputs.nixosModules.work
    outputs.nixosModules.security
    outputs.nixosModules.virtualization
  ];

  # nix settings that should 100% be global
  #nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    trusted-users = ["root" "@wheel"]; # I am very trustworthy with infinite power.
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      # nix-community
      "https://nix-community.cachix.org"
      # hyprland
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # import the overlays
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
  };

  # grub (mount efi partition to /boot/efi)
  # why /boot/efi? instead of /efi?
  # 1. when dualbooting, windows makes the efi partition 100mb instead of 512mb+ (we need this for generations
  # and intel microcode)
  # 2. nixos does not like /efi :(
  # 3. i dont like systemd boot D:
  # TODO(sako):: add shim secure boot
  # because window and riot games devs :(
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      devices = ["nodev"];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      configurationLimit = 10;
    };
  };

  # this shouldnt cause any issues right?
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dubai";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    # use xorg layout option
    # TODO(sako):: add arabic locale
    useXkbConfig = true;
  };

  # xorg layout
  # change to needed
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "grp:alt_space_toggle, ctrl:swapcaps";

  # already sold soul to corporations \_o_/
  nixpkgs.config.allowUnfree = true;

  users.users.sako = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio"];
  };

  age.secrets = {
    git-condition1 = {
      file = ./secrets/desktop/git/condition1.age;
      owner = "sako";
      group = "users";
    };
  };

  home-manager.useUserPackages = true;
  home-manager.users.sako = {pkgs, ...}: {
    home.packages = [];
    home.username = "sako";
    home.homeDirectory = "/home/sako";
    programs.bash.enable = true;
    programs.home-manager.enable = true;
    # xdg.configFile.git = {
    #   source = ./config/git;
    # };

    programs.git = {
      enable = true;
      lfs.enable = true;
      includes = [
        {
          condition = "gitdir:~/dev/sako/";
          contents = {
            user = {
              name = "Sakooooo";
              email = "78461130+Sakooooo@users.noreply.github.com";
            };
            commit = {gpgsign = true;};
          };
        }
        {
          condition = "gitdir:~/nixos/";
          contents = {
            user = {
              name = "Sakooooo";
              email = "78461130+Sakooooo@users.noreply.github.com";
            };
            commit = {gpgsign = true;};
          };
        }
        {
          condition = "gitdir:~/dev/qwq/";
          path = config.age.secrets.git-condition1.path;
        }
      ];
      extraConfig = {
        color.ui = "auto";
        init.defaultBranch = "master";
        pull.rebase = true;
      };
    };
  };
  # bare minimum
  environment.systemPackages = with pkgs; [
    vim # backup
    wget # double u get
    killall # die processes
    unzip # zip file
    gh # github
    htop # htop
    tree # trees
    ripgrep # better grep may help later
    inputs.agenix.packages.${system}.default # agenix
    colmena # deployment tool
    attic-client # caching tool
    socat # to proxy ssh
    git-crypt # for managing some other secrets
  ];

  age.secretsDir = "/run/secrets";

  # you phisiclally cannot live without this
  # litearlly!  ! ! ! ! !
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    settings = {
      allow-emacs-pinentry = "";
      allow-loopback-pinentry = "";
      default-cache-ttl = "28800";
      max-cache-ttl = "28800";
    };
    # enableSSHSupport = true;
  };

  # programs.git = {
  #   enable = true;
  #   package = pkgs.gitFull;
  # };
}
