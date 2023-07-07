{ options, config, lib, pkgs, ...}: 
with lib;
let cfg = config.modules.desktop.game.lutris;
in {
  options.modules.desktop.game.lutris = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      lutris 
    ];
  };
}
