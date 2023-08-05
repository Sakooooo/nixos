# nixd nix lsp using nix and nixpkgs
# where has this been my whole life
{ inputs, outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.nixd;
in
{
  options.modules.dev.nixd = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.nixd
      nixpkgs-fmt
    ];
  };
}
