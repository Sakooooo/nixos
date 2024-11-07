{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.tailscale;
in {
  options.modules.desktop.tailscale = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable { services.tailscale = { enable = true; }; };
}
