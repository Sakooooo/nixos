{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.chat.whatsapp;
in
{
  options.modules.desktop.chat.whatsapp = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      whatsapp-for-linux
    ];
  };
}
