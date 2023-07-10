{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.projects.sakoEngine;
in
{
  options.modules.dev.projects.sakoEngine = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
    ];
  };
}
