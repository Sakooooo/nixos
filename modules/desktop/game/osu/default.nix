{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.game.osu;
in {
  options.modules.desktop.game.osu = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [ osu-lazer-bin ];
  };
}
