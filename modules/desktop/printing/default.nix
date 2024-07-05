{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.printing;
in {
  options.modules.desktop.printing = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # enable printing itself
    services.printing.enable = true;

    # autodiscovery of printers
    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

  };
}
