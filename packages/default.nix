# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  nullpomino = pkgs.callPackage ./nullpomino.nix { };
  ddns-updater = pkgs.callPackage ./ddns-updater.nix { };
  akkoma-emoji.sakomoji = pkgs.callPackage ./sakomoji.nix { };
}
