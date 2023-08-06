{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.nil;
in
{
  options.modules.dev.nil = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nil
    ];
  };
}
