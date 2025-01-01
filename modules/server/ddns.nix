{ config, lib, pkgs, ... }:
with lib;
let cfg = config.void.server.ddns;
in {
  options.void.server.ddns = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services = let
      ddns-updater-updated =
        pkgs.callPackage ../../packages/ddns-updater.nix { };
    in {

      ddns-updater = {
        enable = true;
        package = ddns-updater-updated;
        environment = lib.mkForce {
          "PEROID" = "5m";
          "DATADIR" = "/var/lib/ddns-updater";
        };
      };

      nginx.virtualHosts = {
        "ddns.sako.box" = {
          locations."/" = { proxyPass = "http://localhost:8000"; };
        };
      };
    };
    users.users.ddns-updater = {
      group = "ddns-updater";
      isSystemUser = true;
    };
    users.groups.ddns-updater = { };

    systemd.services.ddns-updater = {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "ddns-updater";
        Group = "ddns-updater";
      };
    };
  };
}

