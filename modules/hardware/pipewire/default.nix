{ outputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.hardware.pipewire;
in {
  options.modules.hardware.pipewire = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    # resolve racial conflict between 
    # pulseaudio and pipewire
    # its deprecated now the west has fallen
    # sound.enable = lib.mkDefault false;

    hardware.pulseaudio.enable = false;

    # what is this for will source games
    # still work what
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    # unsupported apps that use these
    environment.systemPackages = with pkgs; [ pulseaudio alsa-utils pamixer ];

  };
}

