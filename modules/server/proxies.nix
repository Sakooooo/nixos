{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.void.server.proxies;
in {
  options.void.server.proxies = {
    enable = mkEnableOption false;
    openFirewall = mkEnableOption false;
    wgProxyPort = mkOption {
      type = lib.types.port;
      default = 23456;
      description = "port for wireproxy";
    };
    wgHost = mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "host for wireproxy";
    };
  };

  # TODO Maybe expand this later? Setup shadowsocks even lmao
  # Why? I forgot why but it might come in handy later...
  config = let
    configFile = pkgs.writeText "wireproxy config" ''
      WGConfig = /srv/secrets/wireproxy.conf

      [Socks5]
      BindAddress = ${cfg.wgHost}:${toString cfg.wgProxyPort}
    '';
  in
    mkIf cfg.enable {
      networking.firewall = mkIf cfg.openFirewall {
        allowedTCPPorts = [cfg.wgProxyPort];
        allowedUDPPorts = [cfg.wgProxyPort];
      };

      users.groups.wireproxy = {};

      users.users.wireproxy = {
        group = "wireproxy";
        isSystemUser = true;
      };

      systemd.services.wireproxy = {
        unitConfig = {
          description = "A wireguard socks5 proxy";
          after = ["network.target"];
        };
        serviceConfig = {
          Type = "simple";
          User = "wireproxy";
          ExecStart = "${pkgs.wireproxy}/bin/wireproxy --config ${configFile}";
        };
        wantedBy = ["multi-user.target"];
      };
    };
}
