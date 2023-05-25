{
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
      };

      vim.snippets.vsnip.enable = true;

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      vim.languages = {
        enableLSP = true;
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
      vim.autopairs = {
        enable = true;
        nvim-compe.map_complete = false; # auto insert '(' after selecting function
      };

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTreeLua = {
          enable = true;
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

      vim.treesitter.context.enable = true;

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
            "cargo.toml"
            "index.*"
            ".anchor"
            ">.config"
            ">repo"
            ">/nix/store"
          ];
        };
      };

      vim.utility = {
        colorizer.enable = true;
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
          enable = true;
          direction = "tab";
        };
      };

      vim.ui = {
        noice.enable = false;
        smartcolumn.enable = true;
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

      # HACK
      vim.theme.extraConfig = ''
        vim.cmd [[
          source ${./aggregate.vim}
          set foldmethod=expr
          set foldexpr=nvim_treesitter#foldexpr()
          set nofoldenable
          set nowrap
        ]]
        local terminal = require 'toggleterm.terminal'
        _G.LazyGit = terminal.Terminal:new({
          cmd = "lazygit",
          direction = "tab",
          hidden = true,
          on_open = function(term)
            vim.keymap.set('t', '<M-x>', function() term:toggle() end, {silent = true, noremap = true, buffer = term.bufnr})
          end
        })
      '';

      vim.nnoremap = {
        "<M-x>" = "<cmd>execute v:count . 'ToggleTerm'<CR>";
        "<M-n>" = ":BufferLineCycleNext<CR>";
        "<M-p>" = ":BufferLineCyclePrev<CR>";
        "<leader>e" = ":NvimTreeToggle<CR>";
        "<leader>gg" = "<cmd>lua _G.LazyGit:toggle()<CR>";
        "<leader>gP" = ":Gitsigns preview_hunk_inline<CR>";
        "<leader>gdq" = ":DiffviewClose<CR>";
        "<leader>gdd" = ":DiffviewOpen ";
        "<leader>gdm" = ":DiffviewOpen<CR>";
        "<leader>gdh" = ":DiffviewFileHistory %<CR>";
      };

      vim.inoremap = {
        "<C-y>" = "<cmd>lua require'cmp'.mapping.confirm({ select = true })()<CR>";
        "<C-n>" = "<cmd>lua require'cmp'.mapping.select_next_item()()<CR>";
        "<C-p>" = "<cmd>lua require'cmp'.mapping.select_prev_item()()<CR>";
      };

      vim.tnoremap = {
        "<M-x>" = "<cmd>ToggleTerm<CR>";
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
      package = friendly-snippets;
      # friendly-snippets has no setup, these are unrelated but, eh,
      # noone's using it anyways
      setup = ''
        require('lspconfig').yamlls.setup{}
        require('lspconfig').csharp_ls.setup{}
      '';
    }
  ];
}
