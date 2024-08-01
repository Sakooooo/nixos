{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.apps.keepassxc;
in
{
  options.modules.desktop.apps.keepassxc = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      keepassxc
    ];
  };
}
