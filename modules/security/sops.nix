{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.security.sops;
in {
  options.modules.security.sops = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];
  };
}
