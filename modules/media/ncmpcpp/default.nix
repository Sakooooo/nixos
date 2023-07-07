{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.media.ncmpcpp;
in {
  options.modules.media.ncmpcpp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.users.sako = {
      packages = with pkgs; [
        ncmpcpp
      ];
    };
    xdg.configFile = {
      ncmpcpp = {
        source = ../../config/ncmpcpp;
        recursive = true;
      };
    };
  };
}
