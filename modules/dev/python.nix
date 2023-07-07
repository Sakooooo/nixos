{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.dev.python;
in {
  options.modules.dev.python= {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      python3
      python310Packages.pip
    ]; 
  };
}
