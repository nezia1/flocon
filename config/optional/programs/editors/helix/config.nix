{
  self,
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
        yaml-language-server
        rust-analyzer
        rustfmt
        clippy
        clang-tools
        jdt-language-server
        fish-lsp
        tinymist
        tombi
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

  flakeOpts = "(builtins.getFlake \"${self}\").nixosConfigurations.${config.networking.hostName}.options";
  styleCfg = config.local.style;
in {
  hj = {
    packages = [helixWrapped];
    xdg.config.files = {
      "helix/config.toml".source = settingsFormat.generate "helix-config" {
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
        keys = {
          normal = {
            space = {
              # https://github.com/helix-editor/helix/wiki/Recipes#advanced-file-explorer-with-yazi
              e = [
                ":sh rm -f /tmp/unique-file-h21a434"
                ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
                ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                ":open %sh{cat /tmp/unique-file-h21a434}"
                ":redraw"
              ];
            };
          };
        };
      };

      "helix/languages.toml".source = let
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
            {
              name = "yaml";
              language-servers = ["yaml-language-server"];
              auto-format = true;
            }
            {
              name = "rust";
              language-servers = ["rust-analyzer"];
              auto-format = true;
            }
            {
              name = "qml";
              language-servers = ["qmlls"];
              auto-format = true;
            }
            {
              name = "c";
              language-servers = ["clangd"];
              formatter.command = "clang-format";
              auto-format = true;
            }
            {
              name = "java";
              language-servers = ["jdtls"];
              auto-format = true;
            }
            {
              name = "fish";
              language-servers = ["fish-lsp"];
              auto-format = true;
            }
            {
              name = "typst";
              auto-format = true;
              language-servers = ["tinymist"];
            }
            {
              name = "toml";
              language-servers = ["tombi"];
              auto-format = true;
            }
          ];
          language-server = {
            nixd = {
              args = [
                "--semantic-tokens"
                "--inlay-hints"
                "--nixos-options-expr=${flakeOpts}"
              ];
            };
            harper-ls = {
              command = "harper-ls";
              args = ["--stdio"];
            };
            basedpyright = {
              command = "basedpyright-langserver";
              args = ["--stdio"];
            };
            rust-analyzer = {
              config = {
                cargo.features = "all";
                check.command = "clippy";
                completion.callable.snippets = "add_parentheses";
              };
            };
            qmlls = {
              command = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
            };
            clangd = {
              command = "clangd";
            };
            jdtls = {
              command = "jdtls";
              args = [
                "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar"
              ];
            };
            tinymist = {
              command = "tinymist";
              config = {
                exportPdf = "onType";
                outputPath = "$root/target/$dir/$name";
                formatterMode = "typstyle";
                formatterPrintWidth = 80;
                preview.browsing.args = ["--data-plane-host=127.0.0.1:0" "--invert-colors=never" "--open"];
                projectResolution = "lockDatabase";
              };
            };
            tombi = {
              command = "tombi";
              args = ["lsp"];
            };
          };
        };

      "helix/themes/base16.toml".source = theme;

      "helix/yazi-picker.sh".source = pkgs.writeShellScript "yazi-picker" ''
        paths=$(yazi "$2" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

        if [[ -n "$paths" ]]; then
        	zellij action toggle-floating-panes
        	zellij action write 27 # send <Escape> key
        	zellij action write-chars ":$1 $paths"
        	zellij action write 13 # send <Enter> key
        else
        	zellij action toggle-floating-panes
        fi
      '';

      "clangd/config.yaml".source = pkgs.writers.writeYAML "clangd-config.yaml" {
        CompileFlags = {
          Add = [
            "-Wall"
            "-Wextra"
            "-Wpedantic"
          ];
        };
      };
    };
  };
}
