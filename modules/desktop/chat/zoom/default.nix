{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.chat.zoom;
in
{
  options.modules.desktop.chat.zoom = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      zoom-us
    ];
  };
}
