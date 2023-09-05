# i wonder what the difference is
{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.work.onlyoffice;
in
{
  options.modules.work.onlyoffice = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      onlyoffice-bin
    ];
  };
}
