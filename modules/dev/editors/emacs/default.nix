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
    nixpkgs.overlays = [
      inputs.emacs-overlay.overlay
    ];
    # ues daemon
    services.emacs = {
      enable = cfg.daemon;
      install = true;
    #  package = pkgs.emacs29-pgtk;
      package = pkgs.emacsWithPackagesFromUsePackage {
        config = ../../../../config/emacs/emacs.org;
        package = pkgs.emacs-pgtk;
      };
    };
    users.users.sako.packages = with pkgs; [
      # direnv
      direnv
    ];

    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      jetbrains-mono
    ];
  };
}
