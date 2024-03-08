{
  lib,
  config,
  pkgs,
  neovim-flake,
  ...
}: let
  nix2Lua = neovim-flake.lib.nvim.lua.toLuaObject;
  inherit (lib.generators) mkLuaInline;
  setup = module: table: "require('${module}').setup(${nix2Lua table})";
  luaKeymap = action: {
    inherit action;
    lua = true;
  };
in {
  vim = {
    viAlias = false;
    vimAlias = false;
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
        package = pkgs.clang-tools_17;
        server = "clangd";
      };
    };

    sql.enable = true;
    rust = {
      enable = false;
      crates.enable = true;
    };
    ts.enable = true;
    go.enable = true;
    go.dap.enable = false;
    zig.enable = false;
    python.enable = true;
    dart.enable = false;
    elixir.enable = false;
    java = {
      enable = false;
      lsp.package = ["jdt-language-server" "-configuration" "${config.xdg.cacheHome}/jdtls/config" "-data" "${config.xdg.cacheHome}/jdtls/workspace"];
    };
    lua = {
      enable = true;
      lsp.neodev.enable = true;
    };
  };

  vim.lsp.lspconfig.sources = let
    lspconfigSetup = server: {
      custom ? false,
      extraConfig ? {},
    }: ''
      ${lib.optionalString custom ''
        require'lspconfig.configs'.${server} = ${nix2Lua {
          default_config = {
            name = server;
            inherit (extraConfig) cmd filetypes;
            root_dir = extraConfig.root_dir or (mkLuaInline "function(fname) return lspconfig.util.find_git_ancestor(fname) end");
            settings = extraConfig.settings or {};
          };
        }}
      ''}

      lspconfig.${server}.setup ${
        nix2Lua ({
            capabilities = mkLuaInline "capabilities";
            on_attach = mkLuaInline "default_on_attach";
          }
          // extraConfig)
      }
    '';
    mkLspSources = builtins.mapAttrs lspconfigSetup;
  in
    mkLspSources {
      yamlls = {};
      csharp_ls = {};
      elmls = {};
      clojure_lsp = {};
      nixd.extraConfig = {
        cmd = [(lib.getExe pkgs.nixd)];
      };
      roc_ls = {
        custom = true;
        extraConfig = {
          cmd = ["roc_language_server"];
          filetypes = ["roc"];
          root_pattern = mkLuaInline "require'lspconfig.util'.root_pattern('main.roc', '.git')";
        };
      };
    };

  vim.visuals = {
    enable = true;
    nvimWebDevicons.enable = true;
    scrollBar.enable = true;
    smoothScroll.enable = false;
    cellularAutomaton.enable = false;
    fidget-nvim.enable = true;
    indentBlankline = {
      enable = false;
      fillChar = null;
      eolChar = null;
      scope.enabled = true;
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
    sources = builtins.mapAttrs (_key: lib.mkForce) {
      buffer = "[Buffer]";
      copilot = "[Copilot]";
      crates = "[Crates]";

      nvim_lsp = "[LSP]";
      path = "[Path]";
      treesitter = "[Treesitter]";
      vsnip = "[VSnip]";
    };
  };

  vim.filetree = {
    nvimTree = {
      enable = true;
      openOnSetup = false;
      setupOpts = {
        sync_root_with_cwd = true;
        update_focused_file.enable = true;
        actions = {
          change_dir.enable = false;
          change_dir.global = false;
          open_file.window_picker.enable = true;
        };
        renderer = {
          icons.show.git = true;
        };
        view = {
          width = 25;
        };
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
    gitsigns.codeActions.enable = false;
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
      setupOpts = {
        manual_mode = false;
        detection_methods = ["lsp" "pattern"]; # NOTE: lsp detection will get annoying with multiple langs in one project
        patterns = [
          ".git"
          "_darcs"
          ".hg"
          ".bzr"
          ".svn"
          "flake.nix"
          ".anchor"
          ">.config"
          ">repo"
          ">/nix/store"
        ];
      };
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
      mappings.open = null;
      enable = true;
      setupOpts = {
        direction = "tab";
      };
      lazygit = {
        enable = true;
        direction = "float";
      };
    };
  };

  vim.ui = {
    breadcrumbs.enable = false;
    illuminate.enable = true;
  };

  vim.assistant = {
    copilot.enable = true;
  };

  vim.session = {
    nvim-session-manager = {
      enable = true;
      setupOpts = {
        autoload_mode = "Disabled";
      };
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
    vim.g.default_terminal = 1
    vim.filetype.add({
      extension = {
        -- yuck = 'lisp',
      }
    })
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"

    require("tokyonight").setup({
      style = "night",
      on_highlights = function(hl, _)
        hl.WinSeparator = { fg = '#727ca7' }
      end,
    })

    vim.fn.sign_define("DapBreakpointCondition", { text = "⊜", texthl = "ErrorMsg", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "󰜺", texthl = "ErrorMsg", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })

    -- auto ToggleTerm scoping
    do
      local gid = vim.api.nvim_create_augroup("auto_toggleterm_number", {clear = true})
      vim.api.nvim_create_autocmd("TabNew", {
        group = gid,
        callback = function(ev) vim.t.default_terminal = vim.fn.tabpagenr() end,
      })
    end
  '';

  vim.maps.normal = {
    # General
    "<leader>zf".action = ":lua vim.g.formatsave = not vim.g.formatsave<CR>";
    "<leader>e".action = ":NvimTreeToggle<CR>";
    "<leader>ld".action = ":lua vim.diagnostic.setqflist({open = true})<CR>";
    "<leader>lf".action = ":lua vim.lsp.buf.format()<CR>";
    "<leader>li".action = ":lua vim.lsp.buf.implementation()<CR>";

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

    # Toggleterm
    "<M-x>" = luaKeymap "function() require'toggleterm'.toggle(vim.v.count > 0 and vim.v.count or vim.w.default_terminal or vim.t.default_terminal or vim.g.default_terminal or 1) end";
    "<D-x>" = luaKeymap "function() require'toggleterm'.toggle(vim.v.count > 0 and vim.v.count or vim.w.default_terminal or vim.t.default_terminal or vim.g.default_terminal or 1) end";
    "<leader>zt" = {
      desc = ''["scope]Set default ToggleTerm'';
      lua = true;
      action = ''
        function()
          local scope
          if vim.v.register == 'w' or vim.v.register == 't' or vim.v.register == 'g' then
            scope = vim[vim.v.register]
          else
            scope = vim.t
          end

          scope.default_terminal = vim.v.count1
        end
      '';
    };
  };

  vim.maps.normalVisualOp = {
    "<leader>gs".action = ":Gitsigns stage_hunk<CR>";
    "<leader>gr".action = ":Gitsigns reset_hunk<CR>";
    "<leader>lr".action = "<cmd>lua vim.lsp.buf.references()<CR>";

    # ssr.nvim
    "<leader>sr".action = ":lua require('ssr').open()<CR>";

    # ToggleTerm
    "<leader>ct" = {
      # action = ":<C-U>ToggleTermSendVisualLines v:count<CR>";
      action = "':ToggleTermSendVisualLines ' . v:count == 0 ? g:default_terminal : v:count";
      expr = true;
    };
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
    "<M-x>".action = "<cmd>ToggleTerm<cr>";
    "<D-x>".action = "<cmd>ToggleTerm<cr>";
  };

  vim.extraPlugins = with pkgs.vimPlugins; {
    treesitter-roc = {package = pkgs.neovim-treesitter-roc;};
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
      setup = setup "nvim-autopairs" {
        check_ts = true;
        disable_filetype = ["TelescopePrompt"];
        enable_afterquote = false;
        fast_wrap = {
          map = "<M-e>";
          end_key = "l";
          highlight = "PmenuSel";
          highlight_grey = "LineNr";
        };
      };
    };
    scope-nvim = {
      package = scope-nvim;
      setup = setup "scope" {};
    };
    md-img-paste-vim = {
      package = pkgs.md-img-paste-vim;
      setup = ''
        vim.g.mdip_imgdir = "attachments"
      '';
    };
    dap-go = {
      package = nvim-dap-go;
      setup = setup "dap-go" {
        delve = {
          path = lib.getExe pkgs.delve;
        };
      };
    };
    nixrun = {
      package = pkgs.nixrun-nvim;
      setup = setup "nixrun" {};
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
}
