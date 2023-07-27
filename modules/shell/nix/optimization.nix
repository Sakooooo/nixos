{ inputs, options, config, lib, pkgs, ...}:
# this automatically optimizes stuff like nix-store
# and cleans out garbage weekly
# also limits generations
with lib;
let cfg = config.modules.shell.nix.optimize;
in
{
  options.modules.shell.nix.optimize = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable { 
    nix = {
      # garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
      # optimizes store to reduce storage space :)
      # does do alot on the cpu though :p
      # shouldnt be a problem on high core cpus
      # but might be a little problem on 
      # low end machines
      # who cares though free storage woohoo
      settings.auto-optimise-store = true;
    };
  };
}
