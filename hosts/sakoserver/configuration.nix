{ config, pkgs, lib, inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default
    outputs.nixosModules.shell
    outputs.nixosModules.server
    ./hardware-configuration.nix
  ];

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

  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ... }: {
    home.username = "sako";
    home.homeDirectory = "/home/sako";
    home.stateVersion = "24.11";
    programs.bash.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    killall
    unzip
    htop
    ripgrep
  ];

  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];

  modules.shell.tmux.enable = true;

  void = {
    server = {
      isServer = true;
      dns.blocky.enable = true;
      nginx.enable = true;
      postgresql.enable = true;
      services = {
        forgejo.enable = true;
        # headscale.enable = true;
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/#sec-upgrading
  # don't change this pls ty ily thanks
  system.stateVersion = "24.11";
}
