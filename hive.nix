{ inputs, outputs }:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  meta = {
    nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
    specialArgs = { inherit inputs outputs; };
  };

  sakotop = { names, nodes, ... }: {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
    imports = [ ./default.nix ./hosts/sakotop/configuration.nix ];
  };

  sakoserver = { names, nodes, ... }: {
    deployment = { tags = [ "server" ]; };
    imports = [ ./hosts/sakoserver/configuration.nix ];
  };
}
