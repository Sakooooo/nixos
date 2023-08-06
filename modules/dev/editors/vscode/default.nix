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
  options.modules.dev.editors.vscode = {
    enable = mkEnableOption false;
    enableFhs = mkEnableOption false;
  };

  fhs = mkIf cfg.enableFhs {
    users.users.sako.packages = with pkgs; [
      vscode.fhs
    ];
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
        ];
      })
    ];
  };
}
