{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.security.certs;
in {
  options.modules.security.certs = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    security.pki.certificateFiles = [./trust/homelab.pem];
  };
}
