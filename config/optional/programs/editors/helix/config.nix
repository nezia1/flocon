{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib.meta) getExe;

  settingsFormat = pkgs.formats.toml {};
  theme = styleCfg.colors.scheme {
    templateRepo = pins.base16-helix;
    use-ifd = "auto";
  };
  styleCfg = config.local.style;
in {
  hj = {
    packages = [pkgs.helix];
    files = {
      ".config/helix/config.toml".source = settingsFormat.generate "helix-config" {
        theme = "base16";
        editor = {
          line-number = "relative";
          auto-format = true;
          cursor-shape.insert = "bar";
          soft-wrap.enable = true;
          completion-timeout = 5;
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
        };
      };

      ".config/helix/languages.toml".source = pkgs.concatText "helix-languages" [
        (settingsFormat.generate "helix-use-grammars" {
          use-grammars = {only = ["nix"];};
        })
        (settingsFormat.generate "helix-language-config" {
          language = [
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter.command = getExe pkgs.alejandra;
              auto-format = true;
            }
          ];
          language-server = {
            nixd = {
              command = getExe pkgs.nixd;
              args = [
                "--semantic-tokens"
                "--inlay-hints"
              ];
            };
          };
        })
        (settingsFormat.generate "helix-grammar-sources" {
          grammar = [
            {
              name = "nix";
              source.path = pkgs.tree-sitter-grammars.tree-sitter-nix;
            }
          ];
        })
      ];

      ".config/helix/themes/base16.toml".source = theme;
    };
  };
}
