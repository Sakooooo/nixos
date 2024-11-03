{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.thunderbird;
in {
  options.modules.desktop.chat.thunderbird = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = [ pkgs.thunderbird ];

  };
}
