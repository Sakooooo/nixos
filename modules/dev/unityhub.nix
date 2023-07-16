{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.unity;
in
{
  options.modules.dev.unity = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      unityhub
    ];
  };
}
