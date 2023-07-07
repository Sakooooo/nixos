{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.dev.cpp;
in {
  options.modules.dev.cpp = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      cmake
      gcc
      gnumake
    ]; 
  };
}
