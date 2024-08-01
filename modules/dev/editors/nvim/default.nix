{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.dev.editors.nvim;
in {
  options.modules.dev.editors.nvim = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    # because yes
    users.users.sako.packages = with pkgs; [
      neovim
      # flakes
      direnv
      # vscode like git
      lazygit
    ];
    home-manager.users.sako.xdg.configFile.nvim = {
      source = ../../../../config/nvim;
      recursive = true;
    };
  };
}
