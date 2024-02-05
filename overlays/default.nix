{
  inputs,
  config,
  ...
}: let
  nvidiaDriverPackage = config.boot.kernelPackages.nvidiaPackages.stable;
in {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages {pkgs = final;};

  nixpkgs.overlays = [
    inputs.emacs-overlay
  ];
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    polybar = prev.polybar.override {
      pulseSupport = true;
    };
    qutebrowser = prev.qutebrowser.override {
      enableWideVine = true;
    };
    vimix-gtk-themes = prev.vimix-gtk-themes.override {
      themeVariants = ["ruby"];
    };
    dwm = prev.dwm.overrideAttrs (old: {
      src = ../config/dwm;
    });
    nvidiaDriverPackage = prev.nvidiaDriverPackage.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          (prev.fetchpatch {
            url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
            hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          })
        ];
    });
  };

  # lmao when did i add this
  # for a few packages
  # access through pkgs.unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
