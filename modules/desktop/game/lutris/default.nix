{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.game.lutris;
in
{
  options.modules.desktop.game.lutris = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      lutris
    ];
  };
}
