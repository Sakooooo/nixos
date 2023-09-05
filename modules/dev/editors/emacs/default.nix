{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.editors.emacs;
in
{
  options.modules.dev.editors.emacs = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      # bro
      direnv
      # oh my days
      emacs
    ];
    home-manager.users.sako.home.file.".emacs.d" = {
      enable = true;
      source = ../../../../config/emacs;
      recursive = true;
    };
    fonts.fonts = with pkgs; [
      emacs-all-the-icons-fonts
    ];
  };
}
