{ inputs, options, config, lib, pkgs, ...}:
# this automatically optimizes stuff like nix-store
# and cleans out garbage weekly
# also limits generations
let cfg = config.modules.shell.nix.optimize;
in
{
  options.modules.shell.nix.optimize = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable { 
    nix = {
      # garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
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
