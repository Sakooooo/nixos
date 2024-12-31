{ config, pkgs, lib, inputs, outputs, ... }: {
  imports = [ outputs.nixosModules.server ./hardware-configuration.nix ];

  # its you!
  networking.hostName = "sakoserver";

  # why not
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dubai";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  users.users.sako = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [ neovim wget ];

  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];

  void = { server = { isServer = true; }; };

  # https://nixos.org/manual/nixos/stable/#sec-upgrading
  # don't change this pls ty ily thanks
  system.stateVersion = "24.11";
}
