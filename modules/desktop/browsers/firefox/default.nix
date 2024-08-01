{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = lib.mkEnableOption false;
  };

  # TODO add this
  # https://github.com/Dook97/firefox-qutebrowser-userchrome

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;
      };
    };

    programs.browserpass.enable = true;
  };
}
