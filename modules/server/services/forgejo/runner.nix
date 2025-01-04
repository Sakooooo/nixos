{ config, lib, ... }:
with lib;
let cfg = config.void.server.services.forgejo.runner;
in {
  options.void.server.services.forgejo.runner = {
    enable = mkEnableOption false;
  };
  config = mkIf cfg.enable {

    virtualisation.docker.enable = true;

    services.gitea-actions-runner.instances.one = {
      name = "sakoserver-runner";
      enable = true;
      labels = [ "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest" ];
      tokenFile = "/srv/secrets/gitea-actions-runner.env";
      url = "https://git.sako.lol";
    };
  };
}
