{ config, pkgs, lib, inputs, outputs, ...}:
{
  imports = [
    # home manager
    inputs.home-manager.nixosModules.default
    # modules
    #i dont think this is right
    #./modules
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

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
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };

  # this shouldnt cause any issues right?
  networking.hostName = "sakotop";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Cairo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true;
  };
  # already sold soul to corporations \_O_/
  nixpkgs.config.allowUnfree = true;
  
  services.xserver = {
    layout = "us";
  };

  # nix makes alot of garbage so remove it :)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # 100% need this everyone probably knows gpg
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    # enableSSHSupport = true;
  };

  # i dont care what ANYONE says git is always
  # a requirement for a nixos system so it is
  # also bare minimum
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # bare minimum
  # :)
  environment.systemPackages = with pkgs; [
    neovim
    wget
    killall
    alsa-utils
    pulseaudio
    pamixer
    feh
    unzip
    gh
    htop
    tree
  ];

  users.users.sako = {
    shell = pkgs.zsh;
    isNormalUser = true;
    # sudo and networkmanager
    extraGroups = [ "wheel" "networkmanager" ];
  };
  
  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ...}:{
  # CHANGE THIS WHEN THE SYSTEM VERSION
  # CHANGES TOO !!!!!! 
  home.stateVersion = "23.05";
  home.packages = [];
  home.username = "sako";
  home.homeDirectory = "/home/sako";
  programs.bash.enable = true;
  programs.home-manager.enable = true;
  # git
  xdg.configFile = {
    git = {
      source = ../../config/git;
    };
   };
  };


  # change this when nixos update blah blah blah
  # something read the docs haha
  # ok
  system.stateVersion = "23.05"; # read the comment
}
