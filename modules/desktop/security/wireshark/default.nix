{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.security.wireguard;
in
{
  options.modules.desktop.security.wireguard = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = true;
  };
}
