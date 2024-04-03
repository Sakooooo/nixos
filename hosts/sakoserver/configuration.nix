{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # important for later, trust me
  networking.hostName = "sakoserver";
}
