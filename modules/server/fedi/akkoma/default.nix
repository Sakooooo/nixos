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
      "fedi.sako.lol" = {
        credentialsFile = "/srv/secrets/porkbun";
        dnsProvider = "porkbun";
        webroot = null;
      };
      "media.fedi.sako.lol" = {
        credentialsFile = "/srv/secrets/porkbun";
        dnsProvider = "porkbun";
        webroot = null;
      };
    };
    services = {
      akkoma = {
        enable = true;
        package = pkgs.akkoma;
        extraStatic = {
          "emoji/blobs.gg" = pkgs.akkoma-emoji.blobs_gg;
          "static/terms-of-service.html" =
            pkgs.writeText "terms-of-service.html" ''
              <h1>Rules</h1>
              <ol>
                <li>No NSFW <b><i>at all</i></b></li>
                <li>try not to get this server blacklisted thanks :)</li>
              </ol>

              Instance is invite only because I don't know how many users this will handle, if you know any contact methods for the admin go ask him for an invite.
                  …
            '';
          #       "favicon.png" = let
          #         rev = "697a8211b0f427a921e7935a35d14bb3e32d0a2c";
          #       in pkgs.stdenvNoCC.mkDerivation {
          #         name = "favicon.png";

          #         src = pkgs.fetchurl {
          #           url = "https://raw.githubusercontent.com/TilCreator/NixOwO/${rev}/NixOwO_plain.svg";
          #           hash = "sha256-tWhHMfJ3Od58N9H5yOKPMfM56hYWSOnr/TGCBi8bo9E=";
          #         };

          #         nativeBuildInputs = with pkgs; [ librsvg ];

          #         dontUnpack = true;
          #         installPhase = ''
          #   rsvg-convert -o $out -w 96 -h 96 $src
          # '';
        };
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
              # external_user_synchronization = true;
            };
            ":media_proxy" = {
              enabled = true;
              proxy_opts = { redirect_on_failure = true; };
              base_url = "https://media.fedi.sako.lol";
            };
            "Pleroma.Web.Endpoint" = { url.host = "fedi.sako.lol"; };
            "Pleroma.Upload" = {
              base_url = "https://media.fedi.sako.lol/media";
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
        "media.fedi.sako.lol" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = { return = "301 https://fedi.sako.lol"; };
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
    # can't have SHIT in detroit
    users = {
      users.fedifetcher = {
        home = "/var/lib/fedifetcher";
        createHome = true;
        isSystemUser = true;
        group = "fedifetcher";
      };
      groups.fedifetcher = { };
    };

    systemd = let
      configPath = "/srv/secrets/fedifetcher.json";
      state = "/var/lib/fedifetcher";
    in {
      timers.fedifetcher = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnUnitActiveSec = "1m";
          Unit = "fedifetcher.service";
        };
      };
      services.fedifetcher = {
        unitConfig = { ConditionPathExists = configPath; };
        serviceConfig = {
          WorkingDirectory = state;
          Type = "oneshot";
          ExecStart = "${pkgs.fedifetcher}/bin/fedifetcher"
            + " --config ${configPath}" + " --state-dir ${state}";
          User = "fedifetcher";
          Group = "fedifetcher";
        };
      };
    };
  };
}