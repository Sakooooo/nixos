{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.game.tetrio;
in {
  options.modules.desktop.game.tetrio = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      (tetrio-desktop.override {
        withTetrioPlus = true;
      })
    ];
  };
}
