{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.security.wireshark;
in {
  options.modules.desktop.security.wireshark = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
