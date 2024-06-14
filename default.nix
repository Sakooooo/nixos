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
    # modules
    # import for each folder
    # modules/desktop IMPORT
    # modules/desktop/example DO NOT IMPORT,
    # add entry to module's default.nix
    outputs.nixosModules.desktop
    outputs.nixosModules.shell
    outputs.nixosModules.hardware
    outputs.nixosModules.dev
    outputs.nixosModules.media
    outputs.nixosModules.work
    outputs.nixosModules.security
  ];

  # nix settings that should 100% be global
  #nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # import the overlays
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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
  services.xserver.xkb.options = "grp:alt_shift_toggle, ctrl:swapcaps";

  # already sold soul to corporations \_o_/
  nixpkgs.config.allowUnfree = true;

  users.users.sako = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  home-manager.useUserPackages = true;
  home-manager.users.sako = {pkgs, ...}: {
    # CHANGE THIS WHEN THE SYSTEM VERSION CHANGES TOO!!!
    home.packages = [];
    home.username = "sako";
    home.homeDirectory = "/home/sako";
    programs.bash.enable = true;
    programs.home-manager.enable = true;
    xdg.configFile.git = {
      source = ./config/git;
    };
  };
  # bare minimum
  environment.systemPackages = with pkgs; [
    vim # backup
    wget #double u get
    killall # die processes
    alsa-utils # unsupported application
    pulseaudio # unsupported application
    pamixer # unsupported application
    feh # im different
    unzip # zip file
    gh # github
    htop # htop
    tree # trees
  ];
  # you phisiclally cannot live without this
  # litearlly!  ! ! ! ! !
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    # enableSSHSupport = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # read stable version patch notes and fix any issues
  # then you can change this
  #system.stateVersion = "23.05";
  # read comment you read the comment?
}
