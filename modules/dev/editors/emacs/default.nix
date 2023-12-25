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

  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
  ];

  config = mkIf cfg.enable {
    # ues daemon
    services.emacs = {
      enable = cfg.daemon;
      install = true;
      #package = pkgs.emacs29-pgtk;
      package = (pkgs.emacsWithPackagesFromUsePackage {
          config = ../../../../config/emacs/emacs.org;
          defaultInitFile = true;
          alwaysEnsure = true;
          alwaysTangle = true;
          });
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
