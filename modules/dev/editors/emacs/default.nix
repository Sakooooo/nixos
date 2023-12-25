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
      #package = pkgs.emacs29-pgtk;
      package = pkgs.emacsWithPackagesFromUsePackage {
        config = ../../../../config/emacs/init.el;
        package = pkgs.emacs-pgtk;
      };
    };
    users.users.sako.packages = with pkgs; [
      # direnv
      direnv
    ];

    home-manager.users.${user} = {lib, ...}: {
      home.file = {
        ".emacs".source = ../../../../config/emacs;
        "init.el".source = pkgs.runCommand "init.el" {} ''
          cp ${../../../../config/emacs/emacs.org} emacs.org
          ${pkgs.emacs}/bin/emacs -Q --batch ./emacs.org -f org-babel-tangle
          mv init.el $out
        '';

        # Create the auto-saves directory
        # ".emacs.d/auto-saves/.manage-directory".text = "";
      };
    };

    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      jetbrains-mono
    ];
  };
}
