{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.media.resolve;
in
{
  options.modules.desktop.media.resolve = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      davinci-resolve
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "python-2.7.18.6"
    ];
  };
}
