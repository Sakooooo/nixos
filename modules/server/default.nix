{ config, lib, ... }:
with lib;
let cfg = config.void.server;
in {
  imports = [ ./dns ./nginx.nix ./services ./postgresql.nix ./redis.nix ];

  options.void.server = { isServer = mkEnableOption false; };

  config = mkIf cfg.isServer {
    # we need this if you say otherwise ill throw you
    # into a wall
    services.openssh = {
      enable = true;
      ports = [ 69 ];
      openFirewall = true;
      settings = {
        # disable this NEVER enable it
        # PermitRootLogin = "no";
        # its so easy to use keys your grandmother could use it
        PasswordAuthentication = false;
      };
    };

    users.users.sako.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGAwG2Fqs3xNF/6/9GdznH/jUIqxW3aTYvmteuq9odZ sako@sakotop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPSt4TykAJgafU9Trk7sr9wzXhBZxawDIZir0CPyDN sako@sakopc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKprOJ+vtqUL8QQNjRDfIEG7uDPLsxYCpRQoq9blsAvW sakophone"
    ];

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGAwG2Fqs3xNF/6/9GdznH/jUIqxW3aTYvmteuq9odZ sako@sakotop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPSt4TykAJgafU9Trk7sr9wzXhBZxawDIZir0CPyDN sako@sakopc"
    ];

    services.logrotate.enable = true;

    # anything can be a server, even a laptop
    # any say against this is a lie and propaganda
    services.logind.lidSwitch = "ignore";
  };
}
