{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.game.wine;
in
{
  options.modules.desktop.game.wine = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      winetricks
      wineWowPackages.staging
    ];
    nixpkgs.config = {
      wine = {
        release = "unstable";
        build = "wineWow";
      };
    };
  };
}
