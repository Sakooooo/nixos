{ options, config, lib, pkgs, ...}:
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
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
