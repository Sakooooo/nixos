{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      rustup
      cargo
    ]; 
  };
}
