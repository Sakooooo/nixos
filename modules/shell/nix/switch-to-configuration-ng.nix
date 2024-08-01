{ inputs, options, config, lib, ...}:
let
  cfg = config.modules.shell.nix.switch-to-configuration-ng;
in {
  options.modules.shell.nix.switch-to-configuration-ng = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    system.switch = {
      enable = false;
      enableNg = true;
    };
  };
}
