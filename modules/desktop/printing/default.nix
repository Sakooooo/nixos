{ options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.printing;
in {
  options.modules.desktop.printing = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # enable printing itself
    services.printing = {
      enable = true;
      drivers = with pkgs; [ epson-escpr ];
    };

    # autodiscovery of printers
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    users.users.sako.packages = with pkgs; [ simple-scan ];

  };
}
