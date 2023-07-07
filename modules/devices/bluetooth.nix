{ config, pkgs, lib, ...}:
with lib;
let cfg = config.modules.devices.bluetooth;
in {
  options.modules.devices.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
      powerOnBoot = false;
    }; 

    services.blueman.enable = true;
  };
}
