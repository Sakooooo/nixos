{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.security.tor;
in {
  options.modules.security.tor = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {

    age.secrets.torrc = {
      file = ../../secrets/shared/torrc.age;
      owner = "tor";
      group = "tor";
    };

    users.users.sako.packages = with pkgs; [ tor-browser ];

    services.tor = {
      enable = true;
      torsocks.enable = true;
      client = { enable = true; };
    };

    environment.etc = { "tor/torrc".source = config.age.secrets.torrc.path; };

  };
}
