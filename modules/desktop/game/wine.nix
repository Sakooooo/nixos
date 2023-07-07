{ options, config, lib, pkgs, ...}: 
with lib;
let cfg = config.modules.desktop.game.wine;
in {
  options.modules.desktop.game.wine = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      winetricks
      wineWowPackages.staging
    ];
  };
}
