{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.editors.emacs;
in {
  options.modules.dev.editors.emacs = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # ues daemon
    services.emacs = {
      enable = true;
      install = true;
      package = pkgs.emacs29-pgtk;
    };
    users.users.sako.packages = with pkgs; [
      # direnv
      direnv
    ];
    home-manager.users.sako.home.file.".emacs.d" = {
      enable = true;
      source = ../../../../config/emacs;
      recursive = true;
    };
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      jetbrains-mono
    ];
  };
}
