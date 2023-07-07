{ options, config, lib, pkgs, ...}: 
with lib;
let cfg = config.modules.desktop.game.steam;
in {
  options.modules.desktop.game.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      steam
    ];
  };
}
