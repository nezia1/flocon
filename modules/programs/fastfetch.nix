{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
  logo = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/gytis-ivaskevicius/high-quality-nix-content/refs/heads/master/anime/cirnos-logo.png";
    sha256 = "1nr2rqr465h5icj699ssah9mwwiy3n3lnbvslwffxwzimc96hgj2";
  };
in {
  config = lib.mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.fastfetch];
      files = {
        ".config/fastfetch/config.jsonc".text = builtins.toJSON {
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
