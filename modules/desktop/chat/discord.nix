{ options, config, lib, pkgs, ...}: 
with lib;
let cfg = config.modules.desktop.chat.discord;
in {
  options.modules.desktop.chat.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      discord 
    ];
  };
}
