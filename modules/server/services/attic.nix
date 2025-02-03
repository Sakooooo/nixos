{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.void.server.services.attic;
in {
  options.void.server.services.attic = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    # copied from the docs LOL
    services = {
      atticd = {
        enable = true;

        # Replace with absolute path to your environment file
        environmentFile = "/srv/secrets/attic.env";

        settings = {
          listen = "[::]:35743";

          jwt = {};

          storage = {
            type = "local";
            path = "/var/lib/atticd/storage";
          };

          database.url = "postgresql://attic@127.0.0.1:5432/attic";

          # Data chunking
          #
          # Warning: If you change any of the values here, it will be
          # difficult to reuse existing chunks for newly-uploaded NARs
          # since the cutpoints will be different. As a result, the
          # deduplication ratio will suffer for a while after the change.
          chunking = {
            # The minimum NAR size to trigger chunking
            #
            # If 0, chunking is disabled entirely for newly-uploaded NARs.
            # If 1, all NARs are chunked.
            nar-size-threshold = 64 * 1024; # 64 KiB

            # The preferred minimum size of a chunk, in bytes
            min-size = 16 * 1024; # 16 KiB

            # The preferred average size of a chunk, in bytes
            avg-size = 64 * 1024; # 64 KiB

            # The preferred maximum size of a chunk, in bytes
            max-size = 256 * 1024; # 256 KiB
          };
        };
      };
      nginx.virtualHosts."cache.sako.lol" = {
        forceSSL = true;
        enableACME = true;
        http3 = true;
        locations."/" = {proxyPass = "http://localhost:35743";};
      };
    };

    security.acme.certs."cache.sako.lol" = {
      credentialsFile = "/srv/secrets/porkbun";
      dnsProvider = "porkbun";
      webroot = null;
    };
  };
}
