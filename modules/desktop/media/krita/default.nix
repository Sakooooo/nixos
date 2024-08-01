{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.krita;
in
{
  options.modules.desktop.media.krita = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      krita 
    ];
  };
}
