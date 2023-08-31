{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.security.age;
in
{
  options.modules.security.age = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      age
    ];

  };
}
