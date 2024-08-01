{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.desktop.media.resolve;
in
{
  options.modules.desktop.media.resolve = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      sako.davinci-resolve
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "python-2.7.18.6"
    ];
  };
}
