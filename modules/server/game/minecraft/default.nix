{ config, lib, inputs, pkgs, ... }:
with lib;
let cfg = config.void.server.game.minecraft;
in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.void.server.game.minecraft = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = [ inputs.nix-minecraft.overlay ];
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "minecraft-server" ];
    };
    # services = {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers.sakohell = let
        # TODO use npins with this
        modpack = pkgs.fetchPackwizModpack {
          url =
            "https://git.sako.lol/sako/sakopack/raw/branch/master/pack.toml";
          packHash = "sha256-PwZEorwK+ysdTvj+MoSOBLZ+czt+J8gxdmA1gCGjqa0=";
        };
        mcVersion = modpack.manifest.versions.minecraft;
        fabricVersion = modpack.manifest.versions.fabric;
        serverVersion =
          lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
      in {
        enable = true;
        # HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHHAAHAHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH
        openFirewall = true;
        package = pkgs.fabricServers.${serverVersion}.override {
          loaderVersion = fabricVersion;
        };
        whitelist = { Sakoooo = "6b05caca-3d78-4597-aba5-d0f816f94024"; };
        serverProperties = {
          white-list = true;
          difficulty = "normal";
          server-port = 25565;
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
        # };
      };
    };
  };
}
