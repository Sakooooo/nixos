{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.editors.vscode;
in {
  imports = [
    ./fhs.nix
  ];
  options.modules.dev.editors.vscode = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          mkhl.direnv
          vscodevim.vim
          ms-python.vscode-pylance
          ms-vscode.cmake-tools
        ];
      })
    ];
  };
}
