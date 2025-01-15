{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "betterfox";
    rev = "e026ed7d3a763c5d3f96c2680d7bc3340831af4f";
    hash = "sha256-hpkEO5BhMVtINQG8HN4xqfas/R6q5pYPZiFK8bilIDs=";
  };
in {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          DisableTelemetry = true;
          DisablePocket = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          OfferToSaveLogins = false;
          OffertosaveloginsDefault = false;
          PasswordManagerEnabled = false;
          SearchSuggestEnabled = true;

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
      profiles = {
        nezia = {
          settings = {
            "browser.search.suggest.enabled" = true;
            "ui.key.menuAccessKeyFocuses" = false;
          };

          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            darkreader
            proton-pass
            shinigami-eyes
            stylus
            ublock-origin
            violentmonkey
          ];
          # https://git.jacekpoz.pl/poz/niksos/src/commit/a48647a1c5bc6877a1100a65f4dc169b2fc11ed7/hosts/hape/firefox.nix
          search = {
            force = true;
            default = "SearxNG";
            engines = {
              "SearxNG" = {
                urls = [
                  {
                    rels = ["results"];
                    template = "https://search.nezia.dev/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                  {
                    rels = ["suggestions"];
                    template = "https://search.nezia.dev/autocompleter";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                    "type" = "application/x-suggestions+json";
                  }
                ];
              };
              "MyNixOS" = {
                urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
                iconUpdateURL = "https://mynixos.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nx"];
              };
              "Noogle" = {
                urls = [{template = "https://noogle.dev/q?term={searchTerms}";}];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@ng"];
              };
              "GitHub Nix" = {
                # https://github.com/search?q=language%3Anix+NOT+is%3Afork+programs.neovim&type=code
                urls = [{template = "https://github.com/search?q=language:nix NOT is:fork {searchTerms}&type=code";}];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ghn"];
              };
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          # https://github.com/oddlama/nix-config/blob/main/users/myuser/graphical/firefox.nix#L53-L57
          extraConfig = builtins.concatStringsSep "\n" [
            (builtins.readFile "${betterfox}/user.js")
            (builtins.readFile "${betterfox}/Securefox.js")
            (builtins.readFile "${betterfox}/Fastfox.js")
            (builtins.readFile "${betterfox}/Peskyfox.js")
            (builtins.readFile "${betterfox}/Smoothfox.js")
          ];
        };
      };
    };
  };
}
