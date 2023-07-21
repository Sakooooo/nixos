{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.awesome;
in
{
  options.modules.desktop.awesome = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
  };
}
