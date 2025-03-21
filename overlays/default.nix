{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages { pkgs = final; };

  nixpkgs.overlays = [ inputs.emacs-overlay ];
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    polybar = prev.polybar.override { pulseSupport = true; };
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    vimix-gtk-themes =
      prev.vimix-gtk-themes.override { themeVariants = [ "ruby" ]; };
    fluent-gtk-theme = prev.fluent-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "pink" ];
      tweaks = [ "square" ];
    };
    fluent-icon-theme =
      prev.fluent-icon-theme.override { colorVariants = [ "pink" ]; };
    dwm = prev.dwm.overrideAttrs (old: { src = ../config/dwm; });
    ags = prev.ags.overrideAttrs (old: {
      buildInputs = old.buildInputs
        ++ [ inputs.nixpkgs.legacyPackages.x86_64-linux.libdbusmenu-gtk3 ];
    });
    isync = prev.isync.overrideAttrs (old: { withCyrusSaslXoauth2 = true; });
    colmena = inputs.colmena.packages.x86_64-linux.colmena.overrideAttrs
      (old: { patches = old.patches or [ ] ++ [ ./colmena-eval.diff ]; });
    fedifetcher = prev.fedifetcher.overriedAttrs
      (old: { patches = old.patches or [ ] ++ [ ./plsbackfill.diff ]; });
  };

  # incase something breaks
  # access through pkgs.stable
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
