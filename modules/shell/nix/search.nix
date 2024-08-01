{ inputs, options, config, lib, pkgs, ...}:
# this makes 
# nix search nixpkgs <package>
# ALOT faster
let cfg = config.modules.shell.nix.search;
in
{
  options.modules.shell.nix.search = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable { 
    nix = {
     registry = {
      nixpkgs.flake = inputs.nixpkgs;
     };
   };
  };
}
