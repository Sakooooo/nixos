{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.nvidia;
in {
  imports = [
    ./prime.nix
  ];
  options.modules.hardware.nvidia = {
    enable = lib.mkEnableOption false;
    open = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # regardless of if you have intel/nvidia
    # or amd/nvidia this HAS to be nvidia only
    # or else it will not work
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # wayland support
      modesetting.enable = true;

      # set to true if you have an rtx or newer graphics card
      # else set to false
      open = cfg.open;

      # settings
      nvidiaSettings = true;

      # screen tearing fix
      # might consume more power?? dont know, shouldnt be an issue hopefully
      forceFullCompositionPipeline = true;

      # Package
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # maybe change this back once stable has explicit sync?
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
