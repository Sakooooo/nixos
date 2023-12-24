# load stuff
{
  description = "horrible dotfiles for amazing distro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; # nixpkgs stable branch
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # nixpkgs unstable branch
    home-manager = {
      # this manages your dotfiles for the most part
      url = "github:nix-community/home-manager/release-23.11";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    NixOS-WSL = {
      # this makes nixos on wsl a thing
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      # this manages secrets
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
