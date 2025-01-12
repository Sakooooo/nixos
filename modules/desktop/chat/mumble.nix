{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.mumble;
in {
  options.modules.desktop.chat.mumble = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = [ pkgs.mumble ];

  };
}
