{ inputs, options, config, lib, pkgs, ...}:
# this makes 
# nix search nixpkgs <package>
# ALOT faster
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
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    # for theme
    fonts.fonts = with pkgs;[
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

  };
}
