{ outputs, options, config, lib, pkgs, ...}:
with lib; 
let 
  cfg = config.modules.hardware.pipewire;
in
{
  options.modules.hardware.pipewire = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    # resolve racial conflict between 
    # pulseaudio and pipewire
    sound.enable = lib.mkDefault false;

    # what is this for will source games
    # still work what
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
  };
}

