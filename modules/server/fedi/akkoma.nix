{ config, lib, ... }:
with lib;
let cfg = config.void.server.fedi.akkoma;
in {
  options.void.server.fedi.akkoma = { enable = mkEnableOption false; };

  # :(
  config = mkIf cfg.enable {
    services = {
      akkoma = {
        enable = true;
        package = pkgs.akkoma;
      };
    };
  };
}
