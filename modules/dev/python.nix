{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.dev.python;
in {
  options.modules.dev.python = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      python3
      black
      python310Packages.pip
      pyright
    ];
  };
}
