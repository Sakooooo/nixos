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
        environment = { "PEROID" = "5m"; };
      };
      nginx.virtualHosts = {
        "ddns.sako.box" = {
          locations."/" = { proxyPass = "http://localhost:8000"; };
        };
      };
    };
  };
}
