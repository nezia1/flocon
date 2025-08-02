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
        deno
        marksman
        harper
        basedpyright
        ruff
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
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          soft-wrap.enable = true;
          completion-timeout = 5;
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
          indent-guides = {
            character = "|";
            render = true;
          };
        };
      };

      ".config/helix/languages.toml".source = let
        # https://github.com/fufexan/dotfiles/blob/41a68a6fa4312c2e83a813641fcc005e190b1116/home/editors/helix/languages.nix#L9-L12
        deno = lang: {
          command = "deno";
          args = ["fmt" "-" "--ext" lang];
        };
      in
        settingsFormat.generate "helix-language-config" {
          language = [
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter.command = "alejandra";
              auto-format = true;
            }
            {
              name = "markdown";
              language-servers = ["marksman" "harper-ls"];
              formatter = deno "md";
              auto-format = true;
            }
            {
              name = "python";
              language-servers = [
                "basedpyright"
                "ruff"
              ];
              formatter = {
                command = "ruff";
                args = ["format" "-"];
              };
              auto-format = true;
            }
          ];
          language-server = {
            nixd.args = [
              "--semantic-tokens"
              "--inlay-hints"
            ];
            harper-ls = {
              command = "harper-ls";
              args = ["--stdio"];
            };
            basedpyright = {
              command = "basedpyright-langserver";
              args = ["--stdio"];
            };
          };
        };

      ".config/helix/themes/base16.toml".source = theme;
    };
  };
}
