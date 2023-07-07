{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.desktop.keepassxc;
in {
  options.modules.desktop.keepassxc = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      keepassxc
    ];
  };
}
