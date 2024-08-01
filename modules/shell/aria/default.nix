{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.shell.aria;
in
{
  options.modules.shell.aria= {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      aria
    ];
    # home-manager.users.sako = { pkgs, ...}: {
    #   xdg.configFile = {
    #     aria = {
    #       source = ../../../config/aria;
    #       recursive = true;
    #     };
    #   };
    # };
  };
}
