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
          colors = {
            alpha = "1.0";
            background = "010000";
            foreground = "bfbfbf";

            # Normal/Regular colors (0-7)
            regular0 = "010000";
            regular1 = "67514A";
            regular2 = "6A5D4E";
            regular3 = "9B686A";
            regular4 = "9F8975";
            regular5 = "BD7D81";
            regular6 = "D07789";
            regular7 = "bfbfbf";

            # Bright colors (8-15)
            bright0 = "615050";
            bright1 = "67514A";
            bright2 = "6A5D4E";
            bright3 = "9B686A";
            bright4 = "9F8975";
            bright5 = "BD7D81";
            bright6 = "D07788";
            bright7 = "bfbfbf";
          };
        };
      };
    };
  };
}
