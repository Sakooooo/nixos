{
  inputs,
  outputs,
  self,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  meta = {
    nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
    specialArgs = {inherit inputs outputs self;};
  };

  sakotop = {
    names,
    nodes,
    ...
  }: {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
    imports = [./default.nix ./hosts/sakotop/configuration.nix];
  };

  sakopc = {
    names,
    nodes,
    ...
  }: {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
    imports = [./default.nix ./hosts/sakopc/configuration.nix];
  };

  sakoserver = {
    names,
    nodes,
    ...
  }: {
    deployment = {tags = ["server"];};
    imports = [./hosts/sakoserver/configuration.nix];
  };
}
