{ options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.foot;
in {
  options.modules.desktop.foot = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {

    users.users.sako.packages = with pkgs; [ foot ];

    home-manager.users.sako = { pkgs, ... }: {
      programs.foot = {
        enable = true;
        server.enable = false;
        settings = {
          main = {
            term = "xterm-256color";
            font = "JetBrainsMono NF:size=12";
          };
          scrollback = { lines = 1000; };
          cursor = {
            style = "block";
            blink = "yes";
            blink-rate = "1000";
          };
          mouse = { hide-when-typing = "yes"; };
        };
      };
    };
  };
}
