{ outputs, options, config, lib, pkgs, ...}:
with lib;
let 
  cfg = config.modules.hardware.nvidia;
in
{
  options.modules.hardware.nvidia = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    }; 

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # wayland support
      modesetting.enable = true;

      # TODO(sako) add this as a cfg option
      # set to true if you have an rtx or newer graphics card
      # else set to false
      open = false;

      # settings
      nvidiaSettings = true;

      # Package
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # TODO(sako) ALSO add these as a cfg option
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
