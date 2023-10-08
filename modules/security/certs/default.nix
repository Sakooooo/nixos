{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security.certs;
in {
  options.modules.security.certs = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [./trust/homelab.pem];
  };
}
