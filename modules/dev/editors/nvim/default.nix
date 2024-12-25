{ inputs, options, config, lib, pkgs, ... }:
let
  cfg = config.modules.dev.editors.nvim;
  configModule = {
    # custom options 
    # options = { ... };

    config.vim = { theme.enable = true; };
  };
  customNeovim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ configModule ];
  };
in {
  options.modules.dev.editors.nvim = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # because yes
    users.users.sako.packages = with pkgs; [
      # neovim
      customNeovim.neovim
      # flakes
      direnv
      # vscode like git
      # lazygit
    ];
    # home-manager.users.sako.xdg.configFile.nvim = {
    #   source = ../../../../config/nvim;
    #   recursive = true;
    # };
  };
}
