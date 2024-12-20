{ inputs, options, config, lib, pkgs, ... }:
let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = { enable = lib.mkEnableOption false; };

  config = lib.mkIf cfg.enable {
    users.users.sako.shell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      #      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    home-manager.users.sako = { pkgs, ... }: {
      home.file = { };
      programs.direnv = {
        enableZshIntegration = true;
        enable = true;
      };
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          ll = "ls -l";

          # nix thing
          update = "sudo nixos-rebuild switch -v";
          search = "nix search";
          shell = "nix shell";
          run = "nix run";
          cleanup =
            "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
          current-system-tree = "nix-tree /nix/var/nix/profiles/system";
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
    fonts.packages = with pkgs; [ jetbrains-mono nerd-fonts.jetbrains-mono ];
  };
}
