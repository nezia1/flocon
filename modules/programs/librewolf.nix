{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop != null) {
    hj = {
      rum.programs.librewolf = {
        enable = true;

        policies = {
          DisableFirefoxAccounts = false;
          DisableTelemetry = true;
          DisablePocket = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          OfferToSaveLogins = false;
          OffertosaveloginsDefault = false;
          PasswordManagerEnabled = false;
          SearchSuggestEnabled = true;
          FirefoxHome = {
            Pocket = false;
            Snippets = false;
          };

          SearchEngines.Default = "SearxNG";
          SearchEngines.Add = [
            {
              Name = "SearxNG";
              URLTemplate = "https://search.nezia.dev/search?q={searchTerms}";
              Method = "GET";
              SuggestURLTemplate = "https://search.nezia.dev/autocompleter?q={searchTerms}";
            }
            {
              Name = "Nix Packages";
              Alias = "@np";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              Method = "GET";
            }
            {
              Name = "Nix Options";
              Alias = "@no";
              URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              Method = "GET";
            }
            {
              Name = "NixOS Wiki";
              Alias = "@nw";
              URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              Method = "GET";
            }
            {
              Name = "Home Manager Options";
              Alias = "@hmo";
              URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
              Method = "GET";
            }
            {
              Name = "ProtonDB";
              Alias = "@pdb";
              URLTemplate = "https://www.protondb.com/search?q={searchTerms}";
              Method = "GET";
            }
            {
              Name = "Noogle";
              Alias = "@ng";
              URLTemplate = "https://noogle.dev/q?term={searchTerms}";
            }
            {
              Name = "GitHub Nix";
              Alias = "@ghn";
              URLTemplate = "https://github.com/search?q=language:nix NOT is:fork {searchTerms}&type=code";
            }
          ];

          # https://github.com/Sly-Harvey/NixOS/blob/f9da2691ea46565256ad757959cfc26ec6cee10d/modules/programs/browser/firefox/default.nix#L58-L163
          "3rdparty".Extensions = {
            "addon@darkreader.org" = {
              permissions = ["internal:privateBrowsingAllowed"];
              enabled = true;
              automation = {
                enabled = true;
                behavior = "OnOff";
                mode = "system";
              };
              detectDarkTheme = true;
              enabledByDefault = true;
              changeBrowserTheme = false;
              enableForProtectedPages = true;
              fetchNews = false;
              previewNewDesign = true;
            };
            "uBlock0@raymondhill.net" = {
              permissions = ["internal:privateBrowsingAllowed"];
              advancedSettings = [
                [
                  "userResourcesLocation"
                  "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js"
                ]
              ];
              adminSettings = {
                userSettings = {
                  uiTheme = "dark";
                  advancedUserEnabled = true;
                  userFiltersTrusted = true;
                  importedLists = [
                    "https://raw.githubusercontent.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist/main/list.txt"
                  ];
                  selectedFilterLists = [
                    "FRA-0"
                    "adguard-cookies"
                    "adguard-mobile-app-banners"
                    "adguard-other-annoyances"
                    "adguard-popup-overlays"
                    "adguard-social"
                    "adguard-spyware-url"
                    "adguard-widgets"
                    "easylist"
                    "easylist-annoyances"
                    "easylist-chat"
                    "easylist-newsletters"
                    "easylist-notifications"
                    "easyprivacy"
                    "fanboy-cookiemonster"
                    "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                    "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                    "plowe-0"
                    "ublock-annoyances"
                    "ublock-badware"
                    "ublock-cookies-adguard"
                    "ublock-cookies-easylist"
                    "ublock-filters"
                    "ublock-privacy"
                    "ublock-quick-fixes"
                    "ublock-unbreak"
                    "urlhaus-1"
                    "https://raw.githubusercontent.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist/main/list.txt"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
