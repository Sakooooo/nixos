{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.wireguard;
in {
  options.modules.desktop.wireguard = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [ tailscale ];
  };
}
