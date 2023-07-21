# load stuff
{
  description = "horrible dotfiles for amazing distro";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs: 
  let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
    in
    rec {
    # custom packages
    packages = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in import ./packages { inherit pkgs; }
    );
    # dev shell for bootstrap
    devShells = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in import ./shell.nix { inherit pkgs; }
      );
    
    # overlays here
    overlays = import ./overlays { inherit inputs; };

    # modules :D
    nixosModules = import ./modules;

    nixosConfigurations = {
      sakotop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/sakotop/configuration.nix
        ];
      };
    };
    
    #nixosConfigurations = {
      # TODO(sako)::rename this
    #  sakotop = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #    specialArgs = attrs;
    #    modules = [ ./hosts/sakotop ];
    #  };
    #};
  };
}
