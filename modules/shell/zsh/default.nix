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
    #  enableCompletion = true;
    #  promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    home-manager.users.sako = { pkgs, ...}: {
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
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ../../../config/zsh/p10k.zsh; # Some directory containing your p10k.zsh file
      }
     ];
     #initExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
   };

    # for theme
    fonts.fonts = with pkgs;[
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

  };
}
