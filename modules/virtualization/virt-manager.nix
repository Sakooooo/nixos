{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.virtualization.libvirtd;
in
{
  options.modules.virtualization.libvirtd = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    virtualization.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    users.users.sako.extraGroups = [ "libvirtd" ];
  };
}
