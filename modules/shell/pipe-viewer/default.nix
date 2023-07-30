{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.shell.pipe-viewer;
in
{
  options.modules.shell.pipe-viewer = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      pipe-viewer
    ];
  };
}
