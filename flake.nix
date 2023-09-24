# load stuff
{
  description = "horrible dotfiles for amazing distro";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wsl support
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    NixOS-WSL,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
  in rec {
    # custom packages
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./packages {inherit pkgs;}
    );
    # dev shell for bootstrap
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # overlays here
    overlays = import ./overlays {inherit inputs;};

    # modules :D
    nixosModules = import ./modules;

    nixosConfigurations = {
      sakotop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./default.nix
          ./hosts/sakotop/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
      sakopc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./default.nix
          ./hosts/sakopc/configuration.nix
        ];
      };
      sakowsl = nixpkgs.lib.nixosSystem {
        # because theres no hardware-configuration.nix
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nix.registry.nixpkgs.flake = nixpkgs;}
          ./hosts/sakowsl/configuration.nix
          NixOS-WSL.nixosModules.wsl
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
