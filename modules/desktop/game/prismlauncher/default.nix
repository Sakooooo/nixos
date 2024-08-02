{ lib, config, pkgs, options, ...}:
let
  cfg =  config.modules.desktop.game.prismlauncher;
in
{
  options.modules.desktop.game.prismlauncher = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      prismlauncher
    ];
  };
}
