{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.game.grapejuice;
in
{
  options.modules.desktop.game.grapejuice = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      grapejuice
    ];
  };
}
