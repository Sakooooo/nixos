{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.hardware.nvidia.prime;
  busIDType = lib.types.strMatching "([[:print:]]+[\:\@][0-9]{1,3}\:[0-9]{1,2}\:[0-9])?";
in {
  options.modules.hardware.nvidia.prime = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    intelBusId = lib.mkOption {
      type = busIDType;
      default = "";
    };
    nvidiaBusId = lib.mkOption {
      type = busIDType;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        offload = {
          enable = cfg.enable;
          enableOffloadCmd = cfg.enable;
        };
        #intelBusId = "PCI:0:2:0";
        #nvidiaBusId = "PCI:1:0:0";
        intelBusId = cfg.intelBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };
    };
  };
}
