{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.dev.javascript;
in
{
  options.modules.dev.javascript = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      nodejs
      yarn
      nodePackages.typescript-language-server
    ];
  };
}
