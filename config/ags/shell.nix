{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  packages = with pkgs.nodePackages; [ typescript-language-server ];
}
