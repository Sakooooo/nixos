{ inputs, options, config, lib, pkgs, ... }:
let
  sources = import ./sources.nix { inherit pkgs; };
  cfg = config.modules.dev.editors.nvim;
  configModule = {
    # custom options 
    # options = { ... };

    config = {
      vim = {
        theme.enable = true;
        lazy.plugins = {
          vim-wakatime = {
            package = sources.vim-wakatime;
            lazy = false;
          };
        };
      };
    };
  };
  customNeovim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ configModule ];
  };
in {
  imports = [ inputs.nvf.nixosModules.default ];
  options.modules.dev.editors.nvim = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # because yes
    # users.users.sako.packages = with pkgs; [
    #   # neovim
    #   customNeovim.neovim
    #   # flakes
    #   direnv
    #   # vscode like git
    #   # lazygit
    # ];

    programs.nvf = {
      enable = true;
      settings = {
        # vim.lazy = {

        # };
        vim = {
          lsp = { enable = true; };
          utility = { vim-wakatime.enable = true; };
        };
      };
    };

    # home-manager.users.sako.xdg.configFile.nvim = {
    #   source = ../../../../config/nvim;
    #   recursive = true;
    # };
  };
}
