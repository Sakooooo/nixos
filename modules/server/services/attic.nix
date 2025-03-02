{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.services.attic;
in {
  options.void.server.services.attic = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.users.sako.packages = [pkgs.attic-client];

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

          database.url = "postgresql:///atticd?host=/run/postgresql";

          # garbage collection
          garbage-collection = {
            interval = "24 hours";
            default-retention-period = "8 weeks";
          };

          # compression.type = "none";

          # For some reason, attic won't accept pushes of large builds
          # without disabling chunking, surely this does nothing either way LMAO
          chunking = {
            nar-size-threshold = 0;
            min-size = 0;
            avg-size = 0;
            max-size = 0;
          };

          # Data chunking
          #
          # Warning: If you change any of the values here, it will be
          # difficult to reuse existing chunks for newly-uploaded NARs
          # since the cutpoints will be different. As a result, the
          # deduplication ratio will suffer for a while after the change.
          # chunking = {
          #   # The minimum NAR size to trigger chunking
          #   #
          #   # If 0, chunking is disabled entirely for newly-uploaded NARs.
          #   # If 1, all NARs are chunked.
          #   nar-size-threshold = 64 * 1024; # 64 KiB

          #   # The preferred minimum size of a chunk, in bytes
          #   min-size = 16 * 1024; # 16 KiB

          #   # The preferred average size of a chunk, in bytes
          #   avg-size = 64 * 1024; # 64 KiB

          #   # The preferred maximum size of a chunk, in bytes
          #   max-size = 256 * 1024; # 256 KiB
          # };
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
