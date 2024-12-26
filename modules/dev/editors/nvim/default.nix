{ inputs, options, config, lib, pkgs, ... }:
let
  sources = import ./sources.nix { inherit pkgs; };
  cfg = config.modules.dev.editors.nvim;
in {
  imports = [ inputs.nvf.nixosModules.default ];
  options.modules.dev.editors.nvim = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # because yes
    # users.users.sako.packages = with pkgs; [
    #   # flakes
    #   direnv
    #   # vscode like git
    #   # lazygit
    # ];

    programs.nvf = {
      enable = true;
      enableManpages = true;
      settings = {
        # vim.lazy = {

        # };
        vim = {
          lsp = { enable = true; };
          filetree.nvimTree.enable = true;
          precense.neocord = {
            enable = true;
            setupOpts = {
              workspace_text = "Working on something";
            };
          };
          languages = {
             enableLSP = true;
             clang.enable = true;
             python = {
              enable = true;
              format.enable = true;
             };
             nix = {
                enable = true;
                format.enable = true;
             };
          };
          utility = { vim-wakatime.enable = true; };
          extraPlugins = {
            "kanagawa.nvim" = {
              package = sources."kanagawa.nvim";
              setup = ''
              require('kanagawa').setup({ theme = 'dragon'})
              vim.cmd('colorscheme kanagawa')
              ''; 
            };
          };
        };
      };
    };

    # home-manager.users.sako.xdg.configFile.nvim = {
    #   source = ../../../../config/nvim;
    #   recursive = true;
    # };
  };
}
