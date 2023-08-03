{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.virtualization.libvirtd;
in
{
  options.modules.virtualization.libvirtd = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    virtualization.libvirtd.enable = true;
    programs.dconf.enable = true;
    environtment.systemPackages = with pkgs; [
      virt-manager
    ];

    users.users.sako.extraGroups = [ "libvirtd" ];
  };
}
