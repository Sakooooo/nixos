{
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.tablet;
in {
  options.modules.hardware.tablet = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
