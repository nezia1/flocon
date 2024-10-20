{
  inputs,
  config,
  pkgs,
  ...
}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "betterfox";
    rev = "e026ed7d3a763c5d3f96c2680d7bc3340831af4f";
    hash = "sha256-hpkEO5BhMVtINQG8HN4xqfas/R6q5pYPZiFK8bilIDs=";
  };
in {
  imports = [inputs.nur.hmModules.nur];
  # https://github.com/jchv/nixos-config/blob/402c2e612529870544e3a96d5d0cc1a239d003a5/modules/users/john/librewolf.nix#L14-L15
  home.file.".mozilla/firefox/profiles.ini".target = ".librewolf/profiles.ini";
  home.file.".librewolf/nezia".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mozilla/firefox/nezia";
  programs.firefox = {
    enable = true;
    # https://github.com/jchv/nixos-config/blob/402c2e612529870544e3a96d5d0cc1a239d003a5/modules/users/john/librewolf.nix#L18-L23
    package = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
      inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
      wmClass = "LibreWolf";
      libName = "librewolf";
    };
    profiles = {
      nezia = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          proton-pass
          darkreader
          stylus
          sponsorblock
          return-youtube-dislikes
        ];

        settings = {
          "browser.urlbar.suggest.searches" = true;
          "browser.search.suggest.enabled" = true;
          "ui.key.menuAccessKeyFocuses" = false;
          "privacy.clearOnShutdown.cache" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.formdata" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.offlineApps" = false;
          "privacy.clearOnShutdown.sessions" = false;
        };

        # https://git.jacekpoz.pl/poz/niksos/src/commit/a48647a1c5bc6877a1100a65f4dc169b2fc11ed7/hosts/hape/firefox.nix
        search = {
          default = "SearxNG";
          engines = {
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
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };
            "Home Manager Options" = {
              urls = [{template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
            };
            "Arch Wiki" = {
              urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
              icon = "https://archlinux.org/favicon.ico";
              definedAliases = ["@aw"];
            };
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
              definedAliases = ["@sx"];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
        # https://github.com/oddlama/nix-config/blob/main/users/myuser/graphical/firefox.nix#L53-L57
        extraConfig = builtins.concatStringsSep "\n" [
          (builtins.readFile "${betterfox}/Securefox.js")
          (builtins.readFile "${betterfox}/Fastfox.js")
          (builtins.readFile "${betterfox}/Peskyfox.js")
          (builtins.readFile "${betterfox}/Smoothfox.js")
        ];
      };
    };
  };
}
