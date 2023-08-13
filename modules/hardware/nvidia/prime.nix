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
  options.modules.hardware.nvidia.prime = {
    enable = mkEnableOption false;
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
