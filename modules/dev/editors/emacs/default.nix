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


  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    config = ../../../../config/emacs/emacs.org;
    package = cfg.package;
    alwaysEnsure = true;
    alwaysTangle = true;
    extraEmacsPackages = epkgs: [
      epkgs.use-package
      epkgs.mu4e
      # TODO make this check if EXWM is enabled or not
      epkgs.exwm
#     epkgs.sakomodules
      epkgs.eglot-booster
    ];
    # add eglot-lsp-booster package
    override = epkgs: epkgs // {
    eglot-booster = epkgs.trivialBuild {
      pname = "eglot-booster";
      version = "e19dd7ea81bada84c66e8bdd121408d9c0761fe6";

      packageRequires = with pkgs; [ emacs-lsp-booster ];

      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = "eglot-booster";
        rev = "e19dd7ea81bada84c66e8bdd121408d9c0761fe6";
        hash = "sha256-vF34ZoUUj8RENyH9OeKGSPk34G6KXZhEZozQKEcRNhs=";
      };
    };
    };
    # override for modules
#   override = epkgs: epkgs // {
#     sakomodules = epkgs.trivialBuild {
#       pname = "sakomodules";
#       version = "lol";

#       src = ../../../../config/emacs/modules;

#     };
# };
  };
in {
  options.modules.dev.editors.emacs = {
    enable = mkEnableOption false;
    daemon = mkEnableOption true;
    package = mkOption {
      type = with types; package;
      default = pkgs.emacs-unstable;
      description = "pkgs. followed by the name of the emacs overlay package";
    };
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
      # package = pkgs.emacsWithPackagesFromUsePackage {
      #   config = ../../../../config/emacs/emacs.org;
      #   package = pkgs.emacs-unstable;
      #   alwaysEnsure = true;
      #   alwaysTangle = true;
      #   extraEmacsPackages = epkgs: [
      #     epkgs.use-package
      #     epkgs.mu4e
      #   ];
      # };
      package = myEmacs;
    };
    users.users.sako.packages = with pkgs; [
      # direnv
      direnv
      # mu for email
      mu
      # sync
      isync
      # doc-view
      unoconv
      # org to pdf
      # this might be bloat...
      texliveFull
      # ement.el
      pantalaimon
    ];

    home-manager.users.sako = {lib, ...}: {
      home.file = {
        ".emacs.d/init.el".source = pkgs.runCommand "init.el" {} ''
          cp ${../../../../config/emacs/emacs.org} emacs.org
          ${pkgs.emacs}/bin/emacs -Q --batch ./emacs.org -f org-babel-tangle
          mv init.el $out
        '';
        ".emacs.d/icon.png".source = ../../../../config/emacs/icon.png;
      };
    };

    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      jetbrains-mono
    ];
  };
}
