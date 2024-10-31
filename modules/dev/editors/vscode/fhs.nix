{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.dev.editors.vscode.fhs;
in {
  options.modules.dev.editors.vscode.fhs = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [ vscodium.fhs ];
  };
}
