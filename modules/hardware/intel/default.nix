{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.hardware.intelgputools;
in
{
  options.modules.hardware.intelgputools = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      intel-gpu-tools
    ];
  };
}
