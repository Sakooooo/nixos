{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
