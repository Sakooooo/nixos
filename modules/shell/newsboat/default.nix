{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.shell.newsboat;
in
{
  options.modules.shell.newsboat= {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      newsboat
    ];
    home-manager.users.sako = { pkgs, ...}: {
      xdg.configFile = {
        newsboat = {
          source = ../../../config/newsboat;
          recursive = true;
        };
      };
    };
  };
}
