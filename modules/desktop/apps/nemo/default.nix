{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.nemo;
in
{
  options.modules.desktop.apps.nemo = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nemo
    ];
  };
}
