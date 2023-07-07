{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.dev.cpp;
in {
  options.modules.dev.cpp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      cmake
      gcc
      gnumake
    ]; 
  };
}
