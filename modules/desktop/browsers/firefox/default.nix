{ options, config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.browsers.firefox;
in
{
  options.modules.desktop.browsers.firefox = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences = {
        toolkit.legacyUserProfileCustomizations.stylesheets = true;
        browser.compactmode.show = true;
      };
    };
  };
}
