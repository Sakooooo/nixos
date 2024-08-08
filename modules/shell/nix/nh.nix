{ inputs, options, config, lib, pkgs, ...}:
# funny nix cli
let cfg = config.modules.shell.nix.nh;
in
{
  options.modules.shell.nix.nh = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable { 
    programs.nh = {
      enable = true;
      # TODO try this later
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/sako/nixos";
    };
  };
}
