{
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.shell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      #      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    home-manager.users.sako = {pkgs, ...}: {
      home.file = {
      };
      programs.direnv = {
        enableZshIntegration = true;
        enable = true;
      };
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          ll = "ls -l";
          update = "sudo nixos-rebuild switch -v";
        };
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.7.0";
              sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
            };
          }
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "powerlevel10k-config";
            src = ../../../config/zsh;
            file = "p10k.zsh";
          }
        ];
      };
    };

    # for theme
    fonts.packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };
}
