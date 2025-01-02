{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.void.server.fedi.akkoma;

  inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkMap;
in {
  options.void.server.fedi.akkoma = { enable = mkEnableOption false; };

  # :(
  config = mkIf cfg.enable {
    security.acme.certs = {
      "social.sako.lol" = {
        credentialsFile = "/srv/secrets/porkbun";
        dnsProvider = "porkbun";
        webroot = null;
      };
      "media.social.sako.lol" = {
        credentialsFile = "/srv/secrets/porkbun";
        dnsProvider = "porkbun";
        webroot = null;
      };
    };
    services = {
      akkoma = {
        enable = true;
        package = pkgs.akkoma;
        extraPackages =
          builtins.attrValues { inherit (pkgs) ffmpeg exiftool imagemagick; };
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
              # AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
              federating = true;
              external_user_synchronization = true;
            };
            ":media_proxy" = {
              enabled = true;
              proxy_opts = { redirect_on_failure = true; };
              base_url = "https://media.social.sako.lol";
            };
            "Pleroma.Web.Endpoint" = { url.host = "social.sako.lol"; };
            "Pleroma.Upload" = {
              base_url = "https://media.social.sako.lol/media";
              filters = map (pkgs.formats.elixirConf { }).lib.mkRaw [
                "Pleroma.Upload.Filter.Exiftool.StripMetadata"
                "Pleroma.Upload.Filter.Dedupe"
                "Pleroma.Upload.Filter.AnonymizeFilename"
              ];
            };

            ":mrf".policies =
              map mkRaw [ "Pleroma.Web.ActivityPub.MRF.SimplePolicy" ];
            ":mrf_simple" = let blocklist = import ./blocklist.nix;
            in {
              # media_nsfw = mkMap blocklist.media_nsfw;
              reject = mkMap blocklist.reject;
              # followers_only = mkMap blocklist.followers_only;
            };
          };
        };
      };
      nginx.proxyCachePath."akkoma-media-cache" = {
        enable = true;
        levels = "1:2";
        inactive = "720m";
        maxSize = "10g";
        useTempPath = false;
        keysZoneName = "akkoma_media_cache";
        keysZoneSize = "10m";
      };
      nginx.virtualHosts = {
        "media.social.sako.lol" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/media" = { proxyPass = "http://unix:/run/akkoma/socket"; };
            "/proxy" = {
              proxyPass = "http://unix:/run/akkoma/socket";
              extraConfig = ''
                proxy_cache akkoma_media_cache;
                 proxy_cache_lock on;
              '';
            };
          };
        };
      };
    };
  };
}
