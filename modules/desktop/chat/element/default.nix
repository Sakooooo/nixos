{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.element;
in {
  options.modules.desktop.chat.element = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs.stable; [ element-desktop-wayland ];

  };
}
