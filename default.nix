{ config, inputs, outputs, pkgs, lib, home-manager, ...}:
{
  imports = [
    # home manager
    inputs.home-manager.nixosModules.default
    # modules
    #i dont think this is right
    outputs.nixosModules.desktop
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

  # TODO(sako):: figure out plymouth and why my system is too fast
  #boot.plymouth.enable = true;


  # this shouldnt cause any issues right?
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
  
}
