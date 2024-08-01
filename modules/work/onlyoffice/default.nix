# i wonder what the difference is

{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.work.onlyoffice;
in
{
  options.modules.work.onlyoffice = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      onlyoffice-bin
    ];
  };
}
