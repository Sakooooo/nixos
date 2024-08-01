{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.blender;
in
{
  options.modules.desktop.media.blender = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      blender 
    ];
  };
}
