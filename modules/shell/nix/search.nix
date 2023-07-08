{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.shell.nix.search;
in
{
  options.modules.shell.nix.search = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable { 
    nix = {
     registry = {
      nixpkgs.flake = nixpkgs;
      nixos-hardware.flake = nixos-hw;
     };
   };
  };
}
