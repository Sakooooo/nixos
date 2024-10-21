{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.dev.nil;
in
{
  options.modules.dev.nil = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nil
      alejandra
      nixfmt
    ];
  };
}
