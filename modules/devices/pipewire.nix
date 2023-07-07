{ options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.devices.pipewire;
in {
  options.modules.devices.pipewire= {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # pipewire hates this
    sound.enable = false;

    hardware.pulseaudio.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
