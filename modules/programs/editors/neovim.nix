{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;

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
          options = {
            tabstop = 4;
            autoindent = false;
          };

          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers = {
              wl-copy.enable = true;
              xsel.enable = true;
            };
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

          autopairs.nvim-autopairs.enable = true;
          autocomplete.nvim-cmp.enable = true;

          lsp.servers.nixd = {
            enable = true;
            cmd = singleton (getExe pkgs.nixd);
          };

          languages = {
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableTreesitter = true;

            nix = {
              enable = true;
              lsp.enable = false; # managed with native nvim lsp
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
