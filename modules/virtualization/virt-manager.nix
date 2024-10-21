{ outputs, options, config, lib, pkgs, ...}:
let
  cfg = config.modules.virtualization.libvirtd;
in
{
  options.modules.virtualization.libvirtd = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
   virtualisation.libvirtd.enable = true;
   programs.virt-manager.enable = true;
   users.users.sako.extraGroups = [ "libvirtd" ];
  };
}
