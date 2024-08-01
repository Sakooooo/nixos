{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.media.ncmpcpp;
in
{
  options.modules.media.ncmpcpp = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      ncmpcpp
    ]; 

    home-manager.users.sako.xdg.configFile.ncmpcpp = {
      source = ../../../config/ncmpcpp;
      recursive = true;
    };
  };
}
