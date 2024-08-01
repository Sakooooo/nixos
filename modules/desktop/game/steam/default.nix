{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.game.steam;
in
{
  options.modules.desktop.game.steam = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      steam
    ];
  };
}
