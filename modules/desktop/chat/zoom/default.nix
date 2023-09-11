{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.chat.zoom;
in
{
  options.modules.desktop.chat.zoom = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      zoom-us
    ];
  };
}
