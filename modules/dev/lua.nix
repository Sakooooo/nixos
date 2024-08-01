{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.dev.lua;
in {
  options.modules.dev.lua = {
    enable = lib.mkEnableOption false;
  };

  config = lib.mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      lua-language-server
      lua
      luarocks
      stylua
      selene
    ];
  };
}
