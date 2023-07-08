{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.example;
in
{
  options.modules.example = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
  };
}
