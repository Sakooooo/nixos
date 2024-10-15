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
            background = "513942";
            foreground = "fbfffc";

            # Normal/Regular colors
            regular0 = "191516";
            regular1 = "ea4c4c";
            regular2 = "4cea50";
            regular3 = "df7620";
            regular4 = "4ca5ea";
            regular5 = "b24cea";
            regular6 = "33eabf";
            regular7 = "766169";

            # Bright colors (8-15)
            bright0 = "4c4043";
            bright1 = "ff5353";
            bright2 = "99ff69";
            bright3 = "df8f4d";
            bright4 = "88c1ea";
            bright5 = "d6a0ea";
            bright6 = "9dead8";
            bright7 = "eaeaea";
          };
        };
      };
    };
  };
}
