{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
    ./plugins
  ];

  xdg.configFile."nvim".source = ./config;

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        preventJunkFiles = true;
        enableLuaLoader = true;
      };

      vim.snippets.vsnip.enable = true;

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = false;
        lspSignature.enable = true;
      };

      vim.debugger.nvim-dap = {
        ui.enable = true;
      };

      vim.languages = {
        enableLSP = true;
        enableDAP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        html.enable = true;
        clang = {
          enable = true;
          lsp = {
            enable = true;
            package = pkgs.clang-tools_15;
            server = "clangd";
          };
        };

        sql.enable = false;
        rust = {
          enable = true;
          crates.enable = true;
        };
        ts.enable = true;
        go.enable = true;
        zig.enable = false;
        python.enable = true;
        dart.enable = false;
        elixir.enable = false;
      };

      vim.lsp.lspconfig.sources = let
        lspconfigSetup = server: extraConfig: ''
          lspconfig.${server}.setup {
            capabilities = capabilities;
            on_attach = default_on_attach;
            ${extraConfig}
          }
        '';
        mkLspSources = builtins.mapAttrs lspconfigSetup;
      in
        mkLspSources {
          yamlls = "";
          csharp_ls = "";
          jdtls = ''
            cmd = {
              "jdt-language-server",
              "-configuration",
              "${config.xdg.cacheHome}/jdtls/config",
              "-data",
              "${config.xdg.cacheHome}/jdtls/workspace",
            },
          '';
          lua_ls = ''cmd = { "${lib.getExe pkgs.lua-language-server}" },'';
        };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = false;
        cellularAutomaton.enable = false;
        fidget-nvim.enable = true;
        indentBlankline = {
          enable = true;
          fillChar = null;
          eolChar = null;
          showCurrContext = true;
        };
        cursorWordline = {
          enable = true;
          lineTimeout = 0;
        };
      };

      vim.statusline = {
        lualine = {
          enable = true;
          theme = "tokyonight";
        };
      };

      vim.theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
      };

      # custom setup at the bottom
      vim.autopairs.enable = false;

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
        mappings = {
          # close = "<C-e>";
          confirm = "<C-y>";
          next = "<C-n>";
          previous = "<C-p>";
          scrollDocsDown = "<C-d>";
          scrollDocsUp = "<C-u>";
        };
      };

      vim.filetree = {
        nvimTreeLua = {
          enable = true;
          openOnSetup = false;
          openTreeOnNewTab = false;
          indentMarkers = true;
          actions = {
            changeDir.global = false;
            openFile.windowPicker.enable = true;
          };
          renderer = {
            rootFolderLabel = null;

            icons.show.git = true;
            icons.glyphs = {
              git = {
                untracked = "U";
              };
            };
          };
          view = {
            width = 25;
            adaptiveSize = false;
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.treesitter = {
        fold = true;
        context.enable = true;
        mappings = {
          incrementalSelection = {
            init = "<M-o>";
            incrementByNode = "<M-o>";
            decrementByNode = "<M-i>";
          };
        };
      };

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      vim.telescope.enable = true;

      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false;
      };

      vim.minimap = {
        minimap-vim.enable = false;
        codewindow.enable = false; # lighter, faster, and uses lua for configuration
      };

      vim.dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.projects = {
        project-nvim = {
          enable = true;
          manualMode = false;
          detectionMethods = ["lsp" "pattern"]; # NOTE: lsp detection will get annoying with multiple langs in one project
          patterns = [
            ".git"
            "_darcs"
            ".hg"
            ".bzr"
            ".svn"
            "Makefile"
            "package.json"
            "flake.nix"
            "index.*"
            ".anchor"
            ">.config"
            ">repo"
            ">/nix/store"
          ];
        };
      };

      vim.utility = {
        icon-picker.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = false;
        };
      };

      vim.notes = {
        mind-nvim.enable = true;
        todo-comments.enable = true;
      };

      vim.terminal = {
        toggleterm = {
          mappings.open = "<M-x>";
          enable = true;
          direction = "tab";
          lazygit = {
            enable = true;
            direction = "tab";
          };
        };
      };

      vim.ui = {
        noice.enable = false;
        smartcolumn.enable = false;
      };

      vim.assistant = {
        copilot.enable = false;
      };

      vim.session = {
        nvim-session-manager = {
          enable = true;
          autoloadMode = "Disabled";
        };
      };

      vim.gestures = {
        gesture-nvim.enable = false;
      };

      vim.comments = {
        comment-nvim.enable = true;
      };

      vim.presence = {
        presence-nvim.enable = false;
      };

      vim.mapTimeout = 0;

      vim.treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        glsl
        java
      ];

      # HACK
      vim.theme.extraConfig = ''
        vim.cmd [[
          call user#general#setup()
          call user#mapping#setup()
        ]]
        vim.opt.wrap = false
        vim.filetype.add({
          extension = {
            yuck = 'lisp',
          }
        })

        require("tokyonight").setup({
          style = "night",
          on_highlights = function(hl, _)
            hl.WinSeparator = { fg = '#727ca7' }
          end,
        })

        vim.fn.sign_define("DapBreakpointCondition", { text = "⊜", texthl = "ErrorMsg", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "󰜺", texthl = "ErrorMsg", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
      '';

      vim.maps.normal = {
        # General
        "<leader>zf".action = ":lua vim.g.formatsave = not vim.g.formatsave<CR>";
        "<leader>e".action = ":NvimTreeToggle<CR>";
        "<leader>ldq".action = ":lua vim.diagnostic.setqflist({open = true})<CR>";

        # Buffer
        "<M-n>".action = ":BufferLineCycleNext<CR>";
        "<M-p>".action = ":BufferLineCyclePrev<CR>";

        # Diffview
        "<leader>gdq".action = ":DiffviewClose<CR>";
        "<leader>gdd".action = ":DiffviewOpen ";
        "<leader>gdm".action = ":DiffviewOpen<CR>";
        "<leader>gdh".action = ":DiffviewFileHistory %<CR>";
        "<leader>gde".action = ":DiffviewToggleFiles<CR>";

        # Git
        "<leader>gu".action = "<cmd>Gitsigns undo_stage_hunk<CR>";
        "<leader>g<C-w>".action = "<cmd>Gitsigns preview_hunk<CR>";
        "<leader>gp".action = "<cmd>Gitsigns prev_hunk<CR>";
        "<leader>gn".action = "<cmd>Gitsigns next_hunk<CR>";
        "<leader>gP".action = "<cmd>Gitsigns preview_hunk_inline<CR>";
        "<leader>gR".action = "<cmd>Gitsigns reset_buffer<CR>";
        "<leader>gb".action = "<cmd>Gitsigns blame_line<CR>";
        "<leader>gD".action = "<cmd>Gitsigns diffthis HEAD<CR>";
        "<leader>gw".action = "<cmd>Gitsigns toggle_word_diff<CR>";

        # Telescope
        "<M-f>".action = ":Telescope resume<CR>";
        "<leader>fq".action = ":Telescope quickfix<CR>";
        "<leader>f/".action = ":Telescope live_grep<cr>";

        # Aerial
        "gO".action = ":AerialToggle<CR>";
      };

      vim.maps.normalVisualOp = {
        "<leader>gs".action = ":Gitsigns stage_hunk<CR>";
        "<leader>gr".action = ":Gitsigns reset_hunk<CR>";
        "<leader>lr".action = "<cmd>lua vim.lsp.buf.references()<CR>";

        # ssr.nvim
        "<leader>sr".action = ":lua require('ssr').open()<CR>";
      };

      vim.maps.terminal = {
        "<M-x>".action = "<cmd>q<CR>";
      };
    };
  };

  vim.extraPlugins = with pkgs.vimPlugins; [
    {
      package = aerial-nvim;
      setup = ''
        require('aerial').setup({
          on_attach = function(bufnr)
            -- vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
            -- vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
          end
        })
      '';
    }
    {
      package = undotree;
      setup = ''
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_TreeVertShape = '│'
      '';
    }
    {
      package = nvim-navic;
      setup = ''
        local navic = require("nvim-navic")
        navic.setup({
          highlight = true,
          lsp = {auto_attach = true,},
        })

        vim.api.nvim_create_autocmd({"LspAttach"}, {
          callback = function()
            vim.wo.winbar = "%!v:lua.require'nvim-navic'.get_location()"
          end
        })
      '';
    }
    {
      package = ssr-nvim;
      setup = "require('ssr').setup {}";
    }
    {
      package = friendly-snippets;
      # friendly-snippets has no setup, these are unrelated but, eh,
      # noone's using it anyways
      setup = ''
        local navic = require("nvim-navic")
        navic.setup({
          highlight = true,
          lsp = {auto_attach = true,},
        })

        vim.api.nvim_create_autocmd({"LspAttach"}, {
          callback = function()
            vim.wo.winbar = "%!v:lua.require'nvim-navic'.get_location()"
          end
        })
      '';
    }
    {
      package = ssr-nvim;
      setup = "require('ssr').setup {}";
    }
    {
      package = friendly-snippets;
      setup = "";
    }
    {
      package = "nvim-autopairs";
      setup = ''
        require('nvim-autopairs').setup({
          check_ts = true, -- treesitter integration
          disable_filetype = { "TelescopePrompt", "lisp" },
          enable_afterquote = false,
          fast_wrap = {
            map = "<M-e>",
            end_key = "e",
            highlight = "PmenuSel",
            highlight_grey = "LineNr",
          },
        })

        do
          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          require'cmp'.event:on('confirm_done', cmp_autopairs.on_confirm_done({
            map_char = { text = "" },
            filetypes = {
              -- ["*"] = {
              --   ["("] = {
              --     kind = {
              --       cmp.lsp.CompletionItemKind.Function,
              --       cmp.lsp.CompletionItemKind.Method,
              --     },
              --     -- handler = handlers["*"]
              --   }
              -- },
              lisp = false,
              nix = false,
              bash = false,
              sh = false,
            },
          }))
        end
      '';
    }
    {
      package = neodev-nvim;
      setup = ''
        require("neodev").setup({})
      '';
    }
  ];
}
