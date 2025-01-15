{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
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

        theme = lib.mkDefault {
          enable = true;
          name = "catppuccin";
          style = "macchiato";
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
          surround.enable = true;
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

        autocomplete.nvim-cmp = {
          enable = true;
        };

        autopairs.nvim-autopairs.enable = true;

        languages = {
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          clang.enable = true;
          python.enable = true;
          ts.enable = true;
          css.enable = true;
          typst.enable = true;
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

    programs.neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;

        font = {
          normal = [];
          size = 14.0;
        };
      };
    };
  };
}
