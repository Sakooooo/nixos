{ config, pkgs, lib, ...}:
with lib;
let cfg = config.modules.dev.editors.nvim;
in {
  options.modules.dev.editors.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
   environment.systemPackages = with pkgs; [
    neovim
   ]; 

   xdg.configFile = {
    nvim = {
      source = ../../../config/nvim;
      recursive = true;
    };
   };
  };
}
