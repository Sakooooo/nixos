{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.csharp;
in
{
  options.modules.dev.csharp = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      omnisharp-roslyn
    ];
  };
}
