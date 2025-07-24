{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib.strings) getName getVersion makeBinPath;

  settingsFormat = pkgs.formats.toml {};
  theme = styleCfg.colors.scheme {
    templateRepo = pins.base16-helix;
    use-ifd = "auto";
  };

  helix = pkgs.helix;
  helixWrapped = let
    extraPackages = attrValues {
      inherit
        (pkgs)
        nixd
        alejandra
        ;
    };
  in
    pkgs.symlinkJoin {
      name = "${getName helix}-wrapped-${getVersion helix}";
      paths = [helix];
      preferLocalBuild = true;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/hx \
          --prefix PATH : ${makeBinPath extraPackages}
      '';
    };

  styleCfg = config.local.style;
in {
  hj = {
    packages = [helixWrapped];
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

      ".config/helix/languages.toml".source = settingsFormat.generate "helix-language-config" {
        language = [
          {
            name = "nix";
            language-servers = ["nixd"];
            formatter.command = "alejandra";
            auto-format = true;
          }
        ];
        language-server = {
          nixd.args = [
            "--semantic-tokens"
            "--inlay-hints"
          ];
        };
      };

      ".config/helix/themes/base16.toml".source = theme;
    };
  };
}
