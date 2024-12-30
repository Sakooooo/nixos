{ config, pkgs, lib, inputs, outputs, ... }: {
  imports = [ outputs.nixosModules.server ./hardware-configuration.nix ];

  # important for later, trust me
  networking.hostName = "sakoserver";

  boot.loader = {
    timeout = 3;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  void = { isServer = true; };
}
