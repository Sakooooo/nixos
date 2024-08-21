{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.shell.cachix;
in
{
  options.modules.shell.cachix = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      cachix
    ];
  };
}
