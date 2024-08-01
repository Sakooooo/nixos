{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.dev.csharp;
in
{
  options.modules.dev.csharp = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      omnisharp-roslyn
    ];
  };
}
