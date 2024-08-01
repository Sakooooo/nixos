{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.chat.teams;
in
{
  options.modules.desktop.chat.teams = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      teams-for-linux
    ];
  };
}
