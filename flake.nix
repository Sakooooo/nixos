# load stuff
{
  description = "Sako's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # nixpkgs unstable branch
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05"; # nixpkgs stable branch because some things break
    home-manager = {
      # this manages your dotfiles for the most part
      url = "github:nix-community/home-manager";
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
    agenix.url = "github:ryantm/agenix";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/0442d57ffa83985ec2ffaec95db9c0fe742f5182";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpaper.url = "github:hyprwm/hyprpaper";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    NixOS-WSL,
    sops-nix,
    emacs-overlay,
    hyprland,
    hyprpaper,
    ags,
    agenix,
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
          agenix.nixosModules.default
        ];
      };
     sakopc = nixpkgs.lib.nixosSystem {
       specialArgs = {inherit inputs outputs;};
       modules = [
         ./default.nix
         ./hosts/sakopc/configuration.nix
       ];
     };
     #sakoserver = nixpkgs.lib.nixosSystem {
     #  specialArgs = {inherit inputs outputs;};
     #  modules = [
     #    ./default.nix
     #    ./hosts/sakoserver/configuration.nix
     #  ];
     #};
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
