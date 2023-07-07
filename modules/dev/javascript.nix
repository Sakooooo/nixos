{ config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.dev.javascript;
in {
  options.modules.dev.javascript = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nodejs
      yarn
    ]; 
  };
}
