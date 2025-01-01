{ config, lib, pkgs, ... }:
with lib;
let cfg = config.void.server.media.qbittorrent;
in {
  options.void.server.media.qbittorrent = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = lib.mdDoc ''
        The directory where qBittorrent stores its data files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        User account under which qBittorrent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "media";
      description = lib.mdDoc ''
        Group under which qBittorrent runs.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        qBittorrent web UI port.
      '';
    };

    torrentPort = mkOption {
      type = types.port;
      default = 8661;
      description = lib.mdDoc ''
        Port for incoming connections
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.qBittorrent.torrentPort to the outside network.
      '';
    };

    openWebUIFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.qBittorrent.port to the outside network.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = literalExpression "pkgs.qbittorrent-nox";
      description = lib.mdDoc ''
        The qbittorrent package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.torrentPort cfg.port ]; };

    users.users.qbittorrent = {
      home = cfg.dataDir;
      useDefaultShell = true;
      group = cfg.group;
      isSystemUser = true;
    };
    users.groups.media = { };

    systemd.services.qbittorrent = {
      # based on the plex.nix service module and
      # https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
            #!${pkgs.bash}/bin/bash

            # Create data directory if it doesn't exist
            if ! test -d "$QBT_PROFILE"; then
              echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
              install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
            fi
          '';
        in "!${preStartScript}";

        ExecStart = "${cfg.package}/bin/qbittorrent-nox";
        UMask = "0002";
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };
  };
}
