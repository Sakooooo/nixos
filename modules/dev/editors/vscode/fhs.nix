{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.editors.vscode.fhs;
in {
  imports = [
    ./fhs.nix
  ];
  options.modules.dev.editors.vscode.fhs = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      vscode.fhs
    ];
  };
}
