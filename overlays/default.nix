{ inputs, ...}:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages { pkgs = final; };

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
      themeVariants = "ruby";
    };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
