{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) fetchurl;
  inherit (lib.generators) toJSON;
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;

  logo = fetchurl {
    url = "https://raw.githubusercontent.com/gytis-ivaskevicius/high-quality-nix-content/refs/heads/master/emoji/nix-owo-transparent.png";
    sha256 = "137k3i7z4va68v4rvrazy26szc7p2w59h7bc2h8japzjyj6xjs71";
  };
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hjem.users.${username} = {
      packages = [pkgs.fastfetch];
      files = {
        ".config/fastfetch/config.jsonc".text = toJSON {} {
          logo = {
            source = logo;
            type = "kitty";
            width = 33;
          };

          modules = [
            {
              type = "title";
              color = {
                user = "35";
                host = "36";
              };
            }
            {
              type = "separator";
              string = "▔";
            }
            {
              type = "os";
              key = "╭─ ";
              format = "{3} ({12})";
              keyColor = "32";
            }
            {
              type = "host";
              key = "├─󰟀 ";
              keyColor = "32";
            }
            {
              type = "kernel";
              key = "├─󰒔 ";
              format = "{1} {2}";
              keyColor = "32";
            }
            {
              type = "shell";
              key = "├─$ ";
              format = "{1} {4}";
              keyColor = "32";
            }
            {
              type = "packages";
              key = "├─ ";
              keyColor = "32";
            }
            {
              type = "uptime";
              key = "╰─󰔚 ";
              keyColor = "32";
            }
            "break"
            {
              type = "display";
              key = "╭─󰹑 ";
              keyColor = "33";
              compactType = "original";
            }
            {
              type = "de";
              key = "├─󰧨 ";
              keyColor = "33";
            }
            {
              type = "wm";
              key = "├─ ";
              keyColor = "33";
            }
            {
              type = "theme";
              key = "├─󰉼 ";
              keyColor = "33";
            }
            {
              type = "icons";
              key = "├─ ";
              keyColor = "33";
            }
            {
              type = "cursor";
              key = "├─󰳽 ";
              keyColor = "33";
            }
            {
              type = "font";
              key = "├─ ";
              format = "{2}";
              keyColor = "33";
            }
            {
              type = "terminal";
              key = "╰─ ";
              format = "{3}";
              keyColor = "33";
            }
            "break"
            {
              type = "colors";
              symbol = "block";
            }
          ];
        };
      };
    };
  };
}
