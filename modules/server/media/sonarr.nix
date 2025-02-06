{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.media.sonarr;
in {
  options.void.server.media.sonarr = {enable = mkEnableOption false;};

  config = mkIf cfg.enable {
    # something something sonarr upstream not updated blah blah blah
    nixpkgs.config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    users.groups.media = {};

    services = {
      sonarr = {
        enable = true;
        group = "media";
      };
      nginx = {
        virtualHosts = {
          "sonarr.sako.box" = {
            forceSSL = true;
            sslCertificate = "/srv/secrets/certs/sako.box.pem";
            sslCertificateKey = "/srv/secrets/certs/sako.box-key.pem";
            locations = {
              "/" = {
                proxyPass = "http://localhost:8989";
              };
            };
          };
        };
      };
    };
  };
}
