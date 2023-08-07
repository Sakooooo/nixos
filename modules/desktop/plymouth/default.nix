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
      extraConfig = ''
        [Daemon]
        ShowDelay=5
      '';
    };
  };
}
