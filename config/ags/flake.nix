{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ags.url = "github:aylur/ags";
  };

  outputs = { self, nixpkgs, ags }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.typescript-language-server
        # includes astal3 astal4 astal-io by default
        (ags.packages.${system}.default.overrideAttrs { 
          extraPackages = [
                    ags.packages.${pkgs.system}.hyprland
          ags.packages.${pkgs.system}.mpris
          ags.packages.${pkgs.system}.battery
          ags.packages.${pkgs.system}.wireplumber
          ags.packages.${pkgs.system}.network
          ags.packages.${pkgs.system}.tray
          ];
        })
      ];
    };
  };
}
