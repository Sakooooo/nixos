{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.chat.whatsapp;
in
{
  options.modules.desktop.chat.whatsapp = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      whatsapp-for-linux
    ];
  };
}
