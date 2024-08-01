# nixd nix lsp using nix and nixpkgs
# where has this been my whole life
{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.dev.nixd;
in {
  options.modules.dev.nixd = {
    enable = lib.mkEnableOption false;
  };

  # TODO(sako):: figure out how .nixd.json works

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.nixd
      alejandra
    ];
  };
}
