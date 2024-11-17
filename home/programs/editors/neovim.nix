{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      enableLuaLoader = true;
      preventJunkFiles = true;
      tabWidth = 4;
      autoIndent = false;
      useSystemClipboard = true;

      luaConfigPost = lib.concatStrings [
        ''
          vim.opt.formatoptions:remove('c')
          vim.opt.formatoptions:remove('r')
          vim.opt.formatoptions:remove('o')
        ''
      ];

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
      theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
      };

      visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
      };

      ui = {
        noice.enable = true;
      };
      notify.nvim-notify.enable = true;

      statusline = {
        lualine = {
          enable = true;
          theme = "auto";
          componentSeparator = {
            left = "";
          };
          sectionSeparator = {
            left = "";
            right = "";
          };

          activeSection = {
            a = [
              ''
                {
                  "mode",
                  separator = { right = "" },
                  right_padding = 2
                }
              ''
            ];
            b = [
              ''
                {
                  "branch",
                  icon = '',
                  separator = { right = "" }
                }
              ''
            ];
            c = [
              ''
                "filename"
              ''
            ];
            x = [
              ''
                {
                  "diagnostics",
                  sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc'},
                  symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
                  colored = true,
                  update_in_insert = false,
                  always_visible = false,
                  diagnostics_color = {
                    color_error = { fg = 'red' },
                    color_warn = { fg = 'yellow' },
                    color_info = { fg = 'cyan' },
                  },
                }
              ''
              ''
                "filetype"
              ''
            ];
            y = [
              ''
                {
                  "progress",
                  separator = { left = "" },
                }
              ''
              ''
              ''
            ];
            z = [
              ''
                {
                  "location",
                  separator = { left = "" },
                  left_padding = 2
                }
              ''
              ''
                {
                  "fileformat",
                  color = {fg='black'},
                  symbols = {
                    unix = '', -- e712
                    dos = '',  -- e70f
                    mac = '',  -- e711
                  },
                }
              ''
            ];
          };

          inactiveSection = {
            a = [
              ''
                "filename"
              ''
            ];
            z = [
              ''
                "location"
              ''
            ];
          };
        };
      };

      git.enable = true;

      utility = {
        vim-wakatime.enable = true;
      };

      lsp = {
        enable = true;
        lspSignature.enable = true;
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

      autocomplete = {
        enable = true;
        alwaysComplete = true;
      };

      autopairs.enable = true;
      languages = {
        enableExtraDiagnostics = true;
        enableFormat = true;
        enableLSP = true;
        enableTreesitter = true;

        nix.enable = true;
        clang.enable = true;
        python.enable = true;
        ts.enable = true;
      };

      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
        grammars = [
          pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix
          pkgs.vimPlugins.nvim-treesitter.builtGrammars.c
          pkgs.vimPlugins.nvim-treesitter.builtGrammars.python
        ];
      };

      binds.whichKey.enable = true;
      filetree.neo-tree.enable = true;

      telescope.enable = true;
    };
  };
}
