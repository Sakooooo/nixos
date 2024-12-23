{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.dev.editors.vscode;
in {
  imports = [ ./fhs.nix ];
  options.modules.dev.editors.vscode = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs;
      [
        (vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions;
            [
              mkhl.direnv
              ms-python.vscode-pylance
              ms-vscode.cmake-tools
              jnoortheen.nix-ide
              rust-lang.rust-analyzer
              golang.go
              leonardssh.vscord
              ms-python.python
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
              name = "better-comments";
              publisher = "aaron-bond";
              version = "3.0.2";
              sha256 = "hQmA8PWjf2Nd60v5EAuqqD8LIEu7slrNs8luc3ePgZc=";
            }];
        })
      ];
  };
}
