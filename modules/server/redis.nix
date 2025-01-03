{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.void.server.redis;
  srv = config.void.server;
in {
  options.void.server.redis = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # Thank you NotAShelf (again lmao)
    services.redis = {
      enable = true;
      vmOverCommit = true;
      servers = {
        forgejo = mkIf srv.services.forgejo.enable {
          enable = true;
          user = "forgejo";
          port = 6371;
          databases = 16;
          logLevel = "debug";
          requirePass = "forgejo";
        };
        nextcloud = mkIf srv.services.local.nextcloud.enable {
          enable = true;
          user = "nextcloud";
          prot = 6372;
          databases = 16;
          logLevel = "debug";
          requirePass = "nextcloud";
        };
      };
    };
  };
}

