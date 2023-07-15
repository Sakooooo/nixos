{ inputs, options, config, lib, pkgs, ...}:
with lib;
let cfg = config.modules.shell.zsh;
in
{
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

    home-manager.users.sako = { pkgs, ...}: {
    home.file = {
      ".zshrc" = {
        enable = true;
        source = ../../../config/zsh/zshrc.zsh;
      };
      ".p10k.zsh" = {
        enable = true;
        source = ../../../config/zsh/p10k.zsh;
      };
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
        };
      }
     ];
    };
   };

    # for theme
    fonts.fonts = with pkgs;[
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

  };
}
