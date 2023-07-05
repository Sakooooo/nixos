# Sako's crappy nixos dotfiles
# cant wait to break my system again :D

{
  description = "horrible dotfiles for an amazing distro";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # use the same packages
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: {
  nixosConfigurations = {
      #TODO(sako):: rename to sakotop
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
