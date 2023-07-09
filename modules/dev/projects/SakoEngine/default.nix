{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.projects.sakoEngine;
in
{
  options.modules.dev.projects.sakoEngine = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      SDL2
      SDL2_image
      xorg.libX11
      xorg.libX11.dev
      xorg.libXcursor
      xorg.libXcursor.dev
      xorg.libXrandr
      xorg.libXrandr.dev
      xorg.libXi
      xorg.libXi.dev
      zlib
    ];
  };
}
