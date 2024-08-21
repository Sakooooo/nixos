{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.chat.cinny;
in {
  options.modules.desktop.chat.cinny = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs.stable; [
      cinny-desktop
    ];

  };
}
