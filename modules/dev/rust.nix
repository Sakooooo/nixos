{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.dev.rust;
in
{
  options.modules.dev.rust= {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      rustup
      cargo
      rust-analyzer
    ];
  };
}
