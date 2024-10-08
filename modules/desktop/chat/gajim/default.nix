{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.gajim;
in {
  options.modules.desktop.chat.gajim = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [ gajim ];

  };
}
