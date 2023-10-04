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
    services.emacs = {
      enable = true;
      install = true;
      package = pkgs.emacs;
    };
    users.users.sako.packages = with pkgs; [
      # bro
      direnv
      # daemon lmao
      #emacs
    ];
    home-manager.users.sako.home.file.".emacs.d" = {
      enable = true;
      source = ../../../../config/emacs;
      recursive = true;
    };
    fonts.fonts = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };
}
