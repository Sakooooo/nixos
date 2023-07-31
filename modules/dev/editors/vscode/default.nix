{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.editors.vscode;
in
{
  options.modules.dev.editors.vscode = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      vscode.fhs
    ];
  };
}
