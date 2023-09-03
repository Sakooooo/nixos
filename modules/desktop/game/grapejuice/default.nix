{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.game.grapejuice;
in
{
  options.modules.desktop.game.grapejuice = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # TODO update package
    users.users.sako.packages = with pkgs; [
    ];
  };
}
