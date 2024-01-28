{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.apps.bitwarden;
in {
  options.modules.desktop.apps.bitwarden = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      bitwarden
    ];
  };
}
