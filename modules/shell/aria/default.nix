{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.shell.aria;
in
{
  options.modules.shell.aria= {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
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
