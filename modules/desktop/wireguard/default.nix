{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wireguard;
in {
  options.modules.desktop.wireguard = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # todo declaritivly setting it up
    networking.wireguard.enable = true;
  };
}
