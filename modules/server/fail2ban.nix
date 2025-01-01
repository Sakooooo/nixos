{ config, lib, ... }:
with lib;
let cfg = config.void.server.fail2ban;
in {
  options.void.server.fail2ban = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # again thank you notashelf (again)
    services.fail2ban = {
      enable = true;
      ignoreIP = [
        "127.0.0.1/8" # localhost
        "100.64.0.0/16"
        "192.168.0.0/16"
      ];
      banaction = "iptables-multiport";
      banaction-allports = lib.mkDefault "iptables-allport";

      maxretry = 7;
      bantime = "10m";
      bantime-increment = {
        enable = true;
        rndtime = "12m";
        overalljails = true;
        multipliers = "4 8 16 32 64 128 256 512 1024 2048";
        maxtime = "10000h"; # ill see you when nix eval times are fast
      };
      daemonSettings = {
        Definition = {
          loglevel = "INFO";
          logtarget = "/var/log/fail2ban/fail2ban.log";
          socket = "/run/fail2ban/fail2ban.sock";
          pidfile = "/run/fail2ban/fail2ban.pid";
          dbfile = "/var/lib/fail2ban/fail2ban.sqlite3";
          dbpurageage = "1d";
        };
      };
    };
  };
}
