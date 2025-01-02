{ config, lib, ... }:
with lib;
let cfg = config.void.server.fedi.akkoma;
in {
  options.void.server.fedi.akkoma = { enable = mkEnableOption false; };

  # :(
  config = mkIf cfg.enable {
    security.acme.certs = {
      "social.sako.lol" = { };
      "media.social.sako.lol" = { };
    };
    services = {
      akkoma = {
        enable = true;
        package = pkgs.akkoma;
        frontends = {
          primary = {
            package = pkgs.akkoma-frontends.akkoma-fe;
            name = "akkoma-fe";
            ref = "stable";
          };
          admin = {
            package = pkgs.akkoma-frontends.admin-fe;
            name = "admin-fe";
            ref = "stable";
          };
        };

        nginx = {
          enableACME = true;
          forceSSL = true;
          # recommendedTlsSettings = true;
          # recommendedOptimisation = true;
          # recommendedGzipSettings = true;
        };

        config = {
          ":pleroma" = {
            ":instance" = {
              name = "v0id";
              description = "Good ass fediverse instance";
              email = "sako@sako.lol";
              registration_open = false;
              invites_enabled = true;
              account_activation_required = false;
              cleanup_attachments = true;
              allow_relay = true;
            };
            ":media_proxy".enabled = false;
            "Pleroma.Web.Endpoint" = { url.host = "social.sako.lol"; };
            "Pleroma.Upload" = {
              base_url = "https://media.social.sako.lol";
              filters = map (pkgs.formats.elixirConf { }).lib.mkRaw [
                "Pleroma.Upload.Filter.Exiftool"
                "Pleroma.Upload.Filter.Dedupe"
                "Pleroma.Upload.Filter.AnonymizeFilename"
              ];
            };
          };
        };
      };
    };
  };
}
