# load stuff
{
  description = "horrible dotfiles for amazing distro";

  inputs = {
      # nixpkgs 
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
      # unstable for a few packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # TODO(sako):: add agenix or sops-nix
      # https://github.com/ryantm/agenix#install-via-flakes
      # https://github.com/Mic92/sops-nix
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
          ./default-options.nix
          ./hosts/sakotop/configuration.nix
        ];
      };
      sakopc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./default-options.nix
          ./hosts/sakopc/configuration.nix
        ];
      };
    };
    
  };
}
