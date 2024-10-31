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
              vscodevim.vim
              ms-python.vscode-pylance
              ms-vscode.cmake-tools
              ms-dotnettools.csharp
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
