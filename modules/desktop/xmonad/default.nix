{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.xmonad;
in
{
  options.modules.desktop.xmoad = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
  # https://nixos.wiki/wiki/XMonad
    services.xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
            ghcArgs = [
      "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
      "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
      "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
    ];
      };
    };
  };
}
