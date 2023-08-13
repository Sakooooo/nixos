{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.nvidia;
  busIDType = lib.types.strMatching "([[:print:]]+[\:\@][0-9]{1,3}\:[0-9]{1,2}\:[0-9])?";
in {
  options.modules.hardware.nvidia = {
    enable = mkEnableOption false;
    prime.enable = mkEnableOption false;
    prime.intelBusId = mkOption {
      type = busIDType;
      default = "";
    };
    prime.nvidiaBusId = mkOption {
      type = busIDType;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # regardless of if you have intel/nvidia
    # or amd/nvidia this HAS to be nvidia only
    # or else it will not work
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # wayland support
      modesetting.enable = true;

      # TODO(sako) add this as a cfg option
      # set to true if you have an rtx or newer graphics card
      # else set to false
      open = false;

      # settings
      nvidiaSettings = true;

      # screen tearing fix
      # might consume more power?? dont know, shouldnt be an issue hopefully
      forceFullCompositionPipeline = true;

      # Package
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # TODO(sako) ALSO add these as a cfg option
      prime = {
        offload = {
          enable = cfg.prime;
          enableOffloadCmd = cfg.prime;
        };
        #intelBusId = "PCI:0:2:0";
        #nvidiaBusId = "PCI:1:0:0";
        intelBusId = cfg.intelBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };
    };
  };
}
