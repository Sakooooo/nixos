{ config, lib, inputs, pkgs, ... }:
with lib;
let cfg = config.void.server.game.minecraft;
in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  options.void.server.game.minecraft = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
    nixpkgs = {
      overlays = [ inputs.nix-minecraft.overlay ];
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkgs) [ "minecraft-server" ];
    };

    services = {
      minecraft-servers.servers.wires =
        let modpack = pkgs.fetchPackwizModpack { url = ./sakopack; };
        in {
          enable = true;
          # HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHHAAHAHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH
          eula = true;
          openFirewall = true;
          package = pkgs.fabrticServers.fabric-1_24_4.override {
            loaderVersion = "0.16.9";
          };
          whitelist = { Sakoooo = "6b05caca-3d78-4597-aba5-d0f816f94024"; };
          serverProperties = {
            white-list = true;
            difficulty = "normal";
            server-port = 25568;
            gamemode = "survival";
          };
          symlinks = { "mods" = "${modpack}/mods"; };
          # files = {
          #   "config" = "${modpack}/config";
          #   "config/mod1.yml" = "${modpack}/config/mod1.yml";
          #   "config/mod2.conf" = "${modpack}/config/mod2.conf";
          #   # You can add files not on the modpack, of course
          #   "config/server-specific.conf".value = { example = "foo-bar"; };
          # };
        };
    };
  };
}
