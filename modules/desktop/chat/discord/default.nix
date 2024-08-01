{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.chat.discord;
in {
  options.modules.desktop.chat.discord = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
      })
    ];
  };
}
