{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.chat.psi-plus;
in {
  options.modules.desktop.chat.psi-plus = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [ psi-plus ];

  };
}
