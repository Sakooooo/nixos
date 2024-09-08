{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.apps.obs;
in {
  options.modules.desktop.apps.obs = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      obs-studio
    ];

    # OBS Virtual camera support
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModprobeConfig = ''
       options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };
}
