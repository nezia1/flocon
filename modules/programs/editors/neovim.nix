{
  lib,
  inputs,
  pkgs,
  config,
  self,
  ...
}: let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) escapeShellArg;

  styleCfg = config.local.style;

  customNeovim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = singleton {
      config.vim =
        {
          viAlias = true;
          vimAlias = true;
          enableLuaLoader = true;
          preventJunkFiles = true;
          useSystemClipboard = true;
          options = {
            tabstop = 4;
            autoindent = false;
          };

          luaConfigPost = ''
            vim.opt.formatoptions:remove('c')
            vim.opt.formatoptions:remove('r')
            vim.opt.formatoptions:remove('o')

            vim.api.nvim_create_autocmd("FileType", {
              pattern = "nix",
              callback = function(opts)
                local bo = vim.bo[opts.buf]
                bo.tabstop = 2
                bo.shiftwidth = 2
              end
             })
          '';

          maps = {
            normal = {
              "<leader>m" = {
                silent = true;
                action = "<cmd>make<CR>";
              }; # Same as nnoremap <leader>m <silent> <cmd>make<CR>
              "<leader>t" = {
                silent = true;
                action = "<cmd>Neotree toggle<CR>";
              };
            };
          };

          ui = {
            noice.enable = true;
            smartcolumn = {
              enable = true;
              setupOpts = {
                custom_colorcolumn = {
                  nix = "110";
                };
              };
            };
          };

          mini = {
            comment.enable = true;
            notify.enable = true;
            surround.enable = true;
            statusline.enable = true;
          };

          git = {
            enable = true;
            gitsigns.enable = true;
          };

          utility = {
            vim-wakatime.enable = true;
            motion.leap = {
              enable = true;
            };
            preview = {
              markdownPreview.enable = true;
            };
          };

          diagnostics = {
            enable = true;
            config = {
              virtual_lines.enable = true;
              underline = false;
            };
          };
          lsp = {
            enable = true;
            lspconfig.enable = true;
            formatOnSave = true;
            mappings = {
              addWorkspaceFolder = "<leader>wa";
              codeAction = "<leader>a";
              goToDeclaration = "gD";
              goToDefinition = "gd";
              hover = "K";
              listImplementations = "gi";
              listReferences = "gr";
              listWorkspaceFolders = "<leader>wl";
              nextDiagnostic = "<leader>k";
              previousDiagnostic = "<leader>j";
              openDiagnosticFloat = "<leader>e";
              removeWorkspaceFolder = "<leader>wr";
              renameSymbol = "<leader>r";
              signatureHelp = "<C-k>";
            };
          };

          autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            setupOpts = {
              fuzzy.implementation = "prefer_rust_with_warning";
              signature.enabled = true;
            };
          };

          autopairs.nvim-autopairs.enable = true;

          languages = {
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableTreesitter = true;

            nix = {
              enable = true;
              lsp = {
                server = "nixd";
                options = let
                  flake = "(builtins.getFlake ${escapeShellArg inputs.self})";
                in {
                  # https://github.com/Nowaaru/nix-diary/blob/23a10f33c447432f2c2e177a5fa74e019c5626e4/users/noire/cfg/nvf/languages.nix#L43
                  nixos.expr = "${flake}.nixosConfigurations.options";
                };
              };
            };
            clang = {
              enable = true;
              dap.enable = true;
            };
            markdown = {
              enable = true;
              extensions = {
                render-markdown-nvim.enable = true;
              };
            };
            python = {
              enable = true;
              dap.enable = true;
            };
            ts.enable = true;
            css.enable = true;
            typst.enable = true;
            zig = {
              enable = true;
              dap.enable = true;
            };
          };

          treesitter = {
            enable = true;
            fold = true;
            context.enable = true;
            autotagHtml = true;
            grammars = [
              pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix
              pkgs.vimPlugins.nvim-treesitter.builtGrammars.c
              pkgs.vimPlugins.nvim-treesitter.builtGrammars.python
            ];
          };

          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
          };

          binds.whichKey.enable = true;
          filetree.neo-tree.enable = true;

          telescope.enable = true;

          spellcheck = {
            enable = true;
            languages = ["en" "fr"];
            programmingWordlist.enable = true;
          };
        }
        // (optionalAttrs styleCfg.enable {
          theme = {
            enable = true;
            name = "base16";

            # grab the base16 variant as `config.local.style.colors.scheme` might be base24
            base16-colors = inputs.basix.schemeData.base16.${styleCfg.colors.schemeName}.palette;
          };
        });
    };
  };
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj = {
      packages = [customNeovim.neovim];
    };
  };
}
