{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
