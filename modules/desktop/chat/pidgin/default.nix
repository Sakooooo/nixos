{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.pidgin;
in {
  options.modules.desktop.chat.pidgin = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs;
      [ (pidgin-with-plugins.override { plugins = [ pidgin-otr ]; }) ];
  };
}
