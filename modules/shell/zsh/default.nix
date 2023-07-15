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
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "powerlevel10k" ];
        theme = "powerlevel10k";
      };
    };
   };

    # for theme
    fonts.fonts = with pkgs;[
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

  };
}
