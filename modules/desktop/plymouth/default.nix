{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.plymouth;
in {
  options.modules.desktop.plymouth = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
    };
    systemd.services.plymouth-quit = {
      preStart = "${pkgs.coreutils}/bin/sleep 3";
    };
  };
}
