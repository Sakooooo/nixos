{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.rust;
in
{
  options.modules.dev.rust= {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      rustup
      cargo
    ];
  };
}
