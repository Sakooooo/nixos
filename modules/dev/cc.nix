{ outputs, options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.dev.cc;
in
{
  options.modules.dev.cc = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    users.users.sako.packages = with pkgs; [
      gcc
      gnumake
      cmake
      clang
      gdb
      pkg-config
      # lsp
      clang-tools
      cmake-language-server
      # lint
      cpplint
    ];
  };
}
