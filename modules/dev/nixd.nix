# nixd nix lsp using nix and nixpkgs
# where has this been my whole life
{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.nixd;
in
{
  options.modules.dev.nixd = {
    enable = mkEnableOption false;
  };

  # TODO(sako):: figure out how .nixd.json works

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.nixd
      nixpkgs-fmt
    ];
  };
}
