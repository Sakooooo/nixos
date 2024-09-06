{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.virtualization.waydroid;
in
{
  options.modules.virtualization.waydroid = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    virtualisation.waydroid.enable = true;
  };
}
