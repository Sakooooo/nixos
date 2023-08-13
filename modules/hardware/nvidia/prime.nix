{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.nvidia.prime;
  busIDType = lib.types.strMatching "([[:print:]]+[\:\@][0-9]{1,3}\:[0-9]{1,2}\:[0-9])?";
in {
  options.modules.hardware.nvidia.prime = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    intelBusId = mkOption {
      type = busIDType;
      default = "";
    };
    nvidiaBusId = mkOption {
      type = busIDType;
      default = "";
    };
  };

  config = mkIf cfg.enable {
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
