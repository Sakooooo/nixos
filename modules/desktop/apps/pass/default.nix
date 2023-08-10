{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.apps.pass;
in {
  options.modules.desktop.apps.pass = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      pass
      pass.withExtensions
      (exts: [exts.pass-otp])
    ];
  };
}
