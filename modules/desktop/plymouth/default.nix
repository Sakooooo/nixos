{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.plymouth;
in {
  options.modules.desktop.plymouth = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
    };
#    systemd.services.plymouth-quit = {
#      preStart = "${pkgs.coreutils}/bin/sleep 7";
#    };
  };
}
