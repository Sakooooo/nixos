{ inputs, options, config, lib, pkgs, ...}:
let cfg = config.modules.shell.nix.tree;
in
{
  options.modules.shell.nix.tree = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable { 
    users.users.sako.packages = with pkgs; [
      nix-tree
    ];
  };
}
