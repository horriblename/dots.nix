{inputs, ...}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
  ];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        # enableEditorconfig = true;
        viAlias = true;
        vimAlias = true;
        # debugMode = {
        #   enable = false;
        #   level = 20;
        #   logFile = "/tmp/nvim.log";
        # };
      };

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
        clang.enable = true;

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
      vim.autopairs.enable = true;

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTreeLua = {
          enable = true;
          openTreeOnNewTab = false;
          indentMarkers = true;
          actions.changeDir.global = false;
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
        gitsigns.codeActions = true;
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
            "Makefile"
            "package.json"
            "index.*"
            ".anchor"
            ">.config"
            ">repo"
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
        copilot.enable = true;
      };

      vim.session = {
        nvim-session-manager.enable = true;
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
        vim.cmd [[source ${./aggregate.vim}]]
      '';

      vim.nnoremap = {
        "<M-x>" = ":ToggleTerm<CR>";
        "<M-n>" = ":BufferLineCycleNext<CR>";
        "<M-p>" = ":BufferLineCyclePrev<CR>";
        "<leader>e" = ":NvimTreeToggle<CR>";
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
}
