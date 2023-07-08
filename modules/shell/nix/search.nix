{ inputs, options, config, lib, pkgs, ...}:
# this makes 
# nix search nixpkgs <package>
# ALOT faster
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
      nixpkgs.flake = inputs.nixpkgs;
     };
   };
  };
}
