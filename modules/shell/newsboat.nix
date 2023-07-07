{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.shell.newsboat;
in {
  options.modules.shell.newsboat= {
    enable = mkOption {
      type = types.bool;
      default = false;
    }; 
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      newsboat
    ]; 
    # TODO(sako):: make newsboat config
  };
}
