{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkEnableOption false;
  };

  # TODO add this
  # https://github.com/Dook97/firefox-qutebrowser-userchrome

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;
      };
    };

    users.users.sako.packages = with pkgs; [
      browserpass
    ];
  };
}
