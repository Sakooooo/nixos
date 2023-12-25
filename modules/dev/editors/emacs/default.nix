{
  outputs,
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.dev.editors.emacs;
in {
  options.modules.dev.editors.emacs = {
    enable = mkEnableOption false;
    daemon = mkEnableOption true;
  };

  config = mkIf cfg.enable {
    # ues daemon
    services.emacs = {
      enable = cfg.daemon;
      install = true;
<<<<<<< HEAD
      package = pkgs.emacs29-pgtk;
=======
      # package = pkgs.emacs29-pgtk;
      package = pkgs.emacsWithPackagesFromUsePackage {
        # org mode files are borked with this right now
        config = ../../../../config/emacs/init.el;

        defaultInitFile = true;

        package = pkgs.emacs29-pgtk;

      };
>>>>>>> parent of 0b03caa (please)
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
