{ options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption false;
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
