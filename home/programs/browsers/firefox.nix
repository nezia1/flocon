{pkgs, ...}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "betterfox";
    rev = "e026ed7d3a763c5d3f96c2680d7bc3340831af4f";
    hash = "sha256-hpkEO5BhMVtINQG8HN4xqfas/R6q5pYPZiFK8bilIDs=";
  };
in {
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      OfferToSaveLogins = false;
      OffertosaveloginsDefault = false;
      PasswordManagerEnabled = false;

      # https://github.com/Sly-Harvey/NixOS/blob/f9da2691ea46565256ad757959cfc26ec6cee10d/modules/programs/browser/firefox/default.nix#L58-L163
      # TODO: declare which block lists are needed
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
            };
          };
        };
      };
    };
    profiles = {
      nezia = {
        settings = {
          "browser.urlbar.suggest.searches" = true;
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
          idontcareaboutcookies
        ];

        # https://git.jacekpoz.pl/poz/niksos/src/commit/a48647a1c5bc6877a1100a65f4dc169b2fc11ed7/hosts/hape/firefox.nix
        search = {
          default = "SearxNG";
          engines = {
            "SearxNG" = {
              urls = [
                {
                  rels = ["results"];
                  template = "https://searx.tiekoetter.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
                {
                  rels = ["suggestions"];
                  template = "https://searx.tiekoetter.com/autocompleter";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  "type" = "application/x-suggestions+json";
                }
              ];
              iconUpdateURL = "https://searx.tiekoetter.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@s"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://wiki.nixos.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@nw"];
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "Noogle" = {
              urls = [{template = "https://noogle.dev/q?term={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@ng"];
            };
            "Home Manager" = {
              urls = [{template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
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
}
