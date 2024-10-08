{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.wireguard;
in {
  options.modules.desktop.wireguard = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    # todo declaritivly setting it up
    networking.wireguard.enable = true;

    users.users.sako.packages = with pkgs; [
      openresolv
    ];
    
  };
}
