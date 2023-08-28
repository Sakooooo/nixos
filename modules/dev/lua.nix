{
  outputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.lua;
in {
  options.modules.dev.lua = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      lua-language-server
      lua
      luarocks
      stylua
      selene
    ];
  };
}
