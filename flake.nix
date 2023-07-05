# load stuff

{
  description = "horrible dotfiles for amazing distro";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ...}@attrs: {
    nixosConfigurations = {
      # TODO(sako)::rename this
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./configuration.nix ];
      };

    };

  };
}
