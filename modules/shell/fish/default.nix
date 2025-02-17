{
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {enable = lib.mkEnableOption false;};

  config = lib.mkIf cfg.enable {
    users.users.sako.shell = pkgs.fish;

    programs.fish = {
      enable = true;
      #      promptInit = "source ${pkgs.fish-powerlevel10k}/share/fish-powerlevel10k/powerlevel10k.fish-theme";
    };

    home-manager.users.sako = {pkgs, ...}: {
      home.file = {};
      programs.direnv = {
        enable = true;
        enableFishIntegration = true;
      };
      programs.fish = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          # nix thing
          update = "sudo nixos-rebuild switch -v";
          search = "nix search";
          shell = "nix shell";
          run = "nix run";
          cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
          current-system-tree = "nix-tree /nix/var/nix/profiles/system";
        };
      };
    };

    # for theme
    fonts.packages = with pkgs; [jetbrains-mono nerd-fonts.jetbrains-mono];
  };
}
