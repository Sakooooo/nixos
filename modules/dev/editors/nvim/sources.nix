{pkgs, ...}: let 
pins = import ../../../../npins;
inherit (pkgs.vimUtils) buildVimPlugin;
sources = {
   vim-wakatime = buildVimPlugin {
        name = "vim-wakatime";
        src = pins.vim-wakatime;
   };
};
in
  sources
