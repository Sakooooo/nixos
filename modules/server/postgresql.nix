{ config, lib, ... }:
with lib;
let cfg = config.void.server.postgresql;
in {
  options.void.server.postgresql = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "forgejo" ];
      ensureUsers = [
        {
          name = "postgres";
          ensureClauses = {
            superuser = true;
            login = true;
            createrole = true;
            createdb = true;
            replication = true;
          };
        }
        {
          name = "forgejo";
          ensureDBOwnereship = true;
        }
      ];
    };
  };
}

