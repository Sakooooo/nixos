{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.editors.nvim;
in
{
  options.modules.dev.editors.nvim = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # because yes 
    environment.systemPackages = with pkgs; [
      neovim
    ];
    home-manager.users.sako.xdg.configFile.nvim = {
      source = ../../../../config/nvim;
      recursive = true;
    };
  };
}
