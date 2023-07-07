{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.desktop.keepassxc;
in {
  options.modules.desktop.keepassxc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      keepassxc
    ];
  };
}
