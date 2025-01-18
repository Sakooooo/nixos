{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.apps.pass;
in {
  options.modules.desktop.apps.pass = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      (pass.withExtensions
        (pkgs: with pkgs; [ pass-otp pass-import pass-genphrase pass-checkup ]))
      rofi-pass
    ];

    # systemd timer to run git pull and git push
    systemd.timers."pass-sync" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "5m";
        Unit = "pass-sync.service";
      };
    };

    systemd.services."pass-sync" = {
      script = ''
        set -eu
        ${pkgs.pass}/bin/pass git pull
        ${pkgs.pass}/bin/pass git push

        XDG_RUNTIME_DIR=/run/user/$(id -u) ${pkgs.libnotify}/bin/notify-send "Passwords synced"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "sako";
      };
    };
  };
}
