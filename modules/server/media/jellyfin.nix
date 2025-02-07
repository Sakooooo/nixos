{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.jellyfin;
in {
  options.void.server.media.jellyfin = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    users.groups.media = {};

    # intro-skipper plugin, https://github.com/intro-skipper/intro-skipper
    # taken from https://wiki.nixos.org/wiki/Jellyfin#Intro_Skipper_plugin
    nixpkgs.overlays = with pkgs; [
      (
        final: prev: {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          });
        }
      )
    ];

    services = {
      jellyfin = {
        enable = true;
        group = "media";
        # television
        openFirewall = true;
      };

      nginx = {
        virtualHosts = {
          "jellyfin.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:8096";
              };
              "/socket" = {
                proxyPass = "http://localhost:8096";
                proxyWebsockets = true;
              };
            };
          };
        };
      };
    };
  };
}
