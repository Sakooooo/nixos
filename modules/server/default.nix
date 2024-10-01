{ config, lib, ... }:
with lib;
let cfg = config.modules.server;
in {
  imports = [ ];

  options.modules.server = { isServer = mkEnableOption false; };

  config = mkIf cfg.isServer {
    # we need this if you say otherwise ill throw you
    # into a wall
    services.openssh = {
      enable = true;
      settings = {
        # disable this NEVER enable it
        PermitRootLogin = "no";
        # its so easy to use keys your grandmother could use it
        PasswordAuthentication = false;
        ports = [ 69 ];
        openFirewall = true;
      };
    };

    users.users.sako.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGAwG2Fqs3xNF/6/9GdznH/jUIqxW3aTYvmteuq9odZ sako@sakotop"
    ];
  };
}
