{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.desktop.kitty;
in {
  options.modules.desktop.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      kitty
    ];
    fonts.fonts = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [
        "JetBrainsMono"
      ];}) 
    ];
    xdg.configFile = {
     kitty = {
      source = ../../config/kitty;
     }; 
    };
  };
}
