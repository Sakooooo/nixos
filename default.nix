{ config, inputs, outputs, pkgs, lib, home-manager, ...}:
{
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
  ];
  
  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # import the overlays
  nixpkgs = {
     overlays = [
       outputs.overlays.additions
       outputs.overlays.modifications
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
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };

  # this shouldnt cause any issues right?
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Cairo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true;
  };
  # already sold soul to corporations \_o_/
  nixpkgs.config.allowUnfree = true;

  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ...}: {
      # CHANGE THIS WHEN THE SYSTEM VERSION CHANGES TOO!!!
      home.stateVersion = "23.05";
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
    pinentryFlavor = "gtk2";
    # enableSSHSupport = true;
  };

  programs.git = {
      enable = true;
      package = pkgs.gitFull;
  };


  # something nixos release
  # something use ful in for mat ion
  # blah blah blah
  # nixos packages type shit
  # change this on every update idiot
  # dont name it to string beans or some shit
  # you idiot
  system.stateVersion = "23.05"; 
  # read comment you read the comment?
}
