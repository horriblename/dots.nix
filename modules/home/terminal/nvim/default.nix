{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  nix2Lua = import ./lib/nix2Lua.nix;
  setup = module: table: "require('${module}').setup ${nix2Lua table}";
in {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
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
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
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
        transparent = true;
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
          scrollDocsDown = "<C-j>";
          scrollDocsUp = "<C-k>";
        };
      };

      vim.filetree = {
        nvimTree = {
          enable = true;
          openOnSetup = false;
          actions = {
            changeDir.enable = false;
            changeDir.global = false;
            openFile.windowPicker.enable = true;
          };
          renderer = {
            icons.show.git = true;
          };
          view = {
            width = 25;
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = false;
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
        breadcrumbs.enable = false;
        illuminate.enable = true;
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

      vim.comments = {
        comment-nvim.enable = true;
      };

      vim.mapTimeout = 0;

      vim.treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        markdown
        markdown-inline
        regex
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

        local direnvExtras = vim.api.nvim_create_augroup("ExtraDirenvRTP", {})
        vim.api.nvim_create_autocmd({"VimEnter", "User DirenvLoaded"}, {
          group = direnvExtras,
          callback = function()
            local extra_rtp = os.getenv('VIM_EXTRA_PATH')
            if extra_rtp then
              local paths = vim.fn.split(extra_rtp, ':')
              for _, path in ipairs(paths) do
                vim.opt.runtimepath:prepend(path)
              end
            end
          end,
        })
      '';

      vim.maps.normal = {
        # General
        "<leader>zf".action = ":lua vim.g.formatsave = not vim.g.formatsave<CR>";
        "<leader>e".action = ":NvimTreeToggle<CR>";
        "<leader>ld".action = ":lua vim.diagnostic.setqflist({open = true})<CR>";

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

        # Image pasre
        "<leader>P".action = ":call mdip#MarkdownClipboardImage()<CR>";

        # vsnip
        "<C-;>".action = "<Plug>(vsnip-jump-next)";
        "<C-,>".action = "<Plug>(vsnip-jump-prev)";
      };

      vim.maps.normalVisualOp = {
        "<leader>gs".action = ":Gitsigns stage_hunk<CR>";
        "<leader>gr".action = ":Gitsigns reset_hunk<CR>";
        "<leader>lr".action = "<cmd>lua vim.lsp.buf.references()<CR>";

        # ssr.nvim
        "<leader>sr".action = ":lua require('ssr').open()<CR>";
      };

      vim.maps.select = {
        # vsnip
        "<C-;>".action = "<Plug>(vsnip-jump-next)";
        "<C-,>".action = "<Plug>(vsnip-jump-prev)";
      };

      vim.maps.insert = {
        # vsnip
        "<C-;>".action = "<Plug>(vsnip-jump-next)";
        "<C-,>".action = "<Plug>(vsnip-jump-prev)";
      };

      vim.maps.terminal = {
        "<M-x>".action = "<cmd>q<CR>";
      };

      vim.extraPlugins = with pkgs.vimPlugins; {
        aerial = {
          package = aerial-nvim;
          setup = setup "aerial" {};
        };
        undotree = {
          package = undotree;
          setup = ''
            vim.g.undotree_ShortIndicators = true
            vim.g.undotree_TreeVertShape = '│'
          '';
        };
        ssr-nvim = {
          package = ssr-nvim;
          setup = "require('ssr').setup {}";
        };
        friendly-snippets = {package = friendly-snippets;};
        direnv = {package = direnv-vim;};
        nvim-autopairs = {
          package = "nvim-autopairs";
          setup = ''
            require('nvim-autopairs').setup({
              check_ts = true, -- treesitter integration
              disable_filetype = { "TelescopePrompt", "lisp" },
              enable_afterquote = false,
              fast_wrap = {
                map = "<M-e>",
                end_key = "l",
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
              },
            })

            do
              local cmp_autopairs = require('nvim-autopairs.completion.cmp')
              require'cmp'.event:on('confirm_done', cmp_autopairs.on_confirm_done({
                map_char = { text = "" },
                filetypes = {
                  haskell = false,
                  lisp = false,
                  nix = false,
                  bash = false,
                  sh = false,
                },
              }))
            end
          '';
        };
        neodev-nvim = {
          package = neodev-nvim;
          setup = setup "neodev" {};
        };
        md-img-paste-vim = {
          package = pkgs.md-img-paste-vim;
          setup = ''
            vim.g.mdip_imgdir = "attachments"
          '';
        };
        nvim-treesitter-textobjects = {
          package = nvim-treesitter-textobjects;
          setup = setup "nvim-treesitter.configs" {
            textobjects = {
              select = {
                enable = true;
                lookahed = true;
                keymaps = {
                  "af" = "@function.outer";
                  "if" = "@function.inner";
                  "ac" = "@class.outer";
                  "ic" = "@class.inner";
                };

                selection_modes = {
                  "@parameter.outer" = "v";
                  "@function.outer" = "V";
                  "@class.outer" = "V";
                };
              };
              swap = {
                enable = true;
                swap_next = {
                  "cx;" = "@parameter.inner";
                };
                swap_previous = {
                  "cx," = "@parameter.inner";
                };
              };

              move = {
                enable = true;
                set_jumps = true;
                goto_next_start = {
                  "]f" = "@function.outer";
                  "]c" = "@class.outer";
                  "]s" = "@scope";
                };
                goto_previous_start = {
                  "[f" = "@function.outer";
                  "[c" = "@class.outer";
                  "[s" = "@scope";
                };
                goto_next_end = {
                  "]F" = "@function.outer";
                  "]C" = "@class.outer";
                };
                goto_previous_end = {
                  "[F" = "@function.outer";
                  "[C" = "@class.outer";
                };
              };
            };
          };
        };
      };
    };
  };
}
