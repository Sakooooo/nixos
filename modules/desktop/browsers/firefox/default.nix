{ options, config, lib, pkgs, ... }:
let cfg = config.modules.desktop.browsers.firefox;
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

    home-manager.users.sako = {
      programs.firefox = {
        enable = true;
        profiles = {
          "user" = {
            id = 0;
            isDefault = true;

            # userChrome = ''
            # '';

            search.default = "DuckDuckGo";
            search.force = true;
            search.engines = {
              "Nix Packages" = {
                urls = [{
                  template =
                    "https://search.nixos.org/packages?channel=unstable";
                  params = [{
                    name = "query";
                    value = "{searchTerms}";
                  }];
                }];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nixpkgs" ];
              };
              "Nix Options" = {
                definedAliases = [ "@nixopts" ];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                urls = [{
                  template =
                    "https://search.nixos.org/options?channel=unstable";
                  params = [{
                    name = "query";
                    value = "{searchTerms}";
                  }];
                }];
              };
              "Home Manager Options" = {
                definedAliases = [ "@homemgropts" ];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                urls = [{
                  template =
                    "https://home-manager-options.extranix.com/release=master";
                  params = [{
                    name = "query";
                    value = "{searchTerms}";
                  }];
                }];
              };
            };
          };
        };
      };

      programs.browserpass = {
        enable = true;
        browsers = [ "firefox" ];
      };

    };

    programs.browserpass.enable = true;
  };
}
