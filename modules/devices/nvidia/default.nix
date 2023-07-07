{ config, pkgs, lib, ...}:
with lib;
let cfg = config.modules.devices.nvidia;
in {
  options.modules.devices.nvidia = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # tell xserver i want this driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # wayland support cause why not
    modesetting.enable = true;

    # TODO(sako):: add this as a cfg option for hosts
    open = false;

    # settings
    nvidiaSettings = true;

    # Package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
   };
  };
}
