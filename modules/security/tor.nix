{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.security.tor;
in {
  options.modules.security.tor = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    services.tor = {
      enable = true;
      torsocks.enable = true;
      client = { enable = true; };
    };
  };
}
