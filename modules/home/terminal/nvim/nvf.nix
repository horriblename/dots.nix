{
  inputs,
  lib,
  config,
  pkgs,
  impurity,
  ...
}: let
  nix2Lua = inputs.nvf.lib.nvim.lua.toLuaObject;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.lists) flatten;
  inherit (lib.attrsets) mapAttrsToList;
  setup = module: table: "require('${module}').setup(${nix2Lua table})";
  luaKeymap = action: {
    inherit action;
    lua = true;
  };
  mkKeymap = mode: key: action: opts: opts // {inherit mode key action;};
in {
  vim = {
    viAlias = false;
    vimAlias = false;
    preventJunkFiles = true;
    enableLuaLoader = true;
    lazy = {
      enable = true;
      plugins = {
        undotree = {
          package = pkgs.vimPlugins.undotree;
          before = ''
            vim.g.undotree_ShortIndicators = true
            vim.g.undotree_TreeVertShape = '│'
          '';
          cmd = ["UndotreeFocus" "UndotreeHide" "UndotreePersistUndo" "UndotreeShow" "UndotreeToggle"];
          keys = [
            (mkKeymap "n" "<leader>u" ":UndotreeToggle<CR>" {})
          ];
        };
        fzf-lua = {
          package = pkgs.vimPlugins.fzf-lua;
          setupModule = "fzf-lua";
          setupOpts = {"@1" = "max-perf";};
          keys = [
            (mkKeymap "n" "<leader>fj" "<cmd>FzfLua jumps<CR>" {})
            (mkKeymap "n" "<leader>fh" "<cmd>FzfLua oldfiles<CR>" {})
            (mkKeymap "n" "<leader>fm" "<cmd>FzfLua marks<CR>" {})
            (mkKeymap "n" "<leader>f\"" "<cmd>FzfLua registers<CR>" {})

            # LSP
            (mkKeymap "n" "<leader>fla" "<cmd>FzfLua lsp_code_actions<CR>" {})
            (mkKeymap "n" "<leader>flD" "<cmd>FzfLua lsp_declarations<CR>" {})
            (mkKeymap "n" "<leader>fld" "<cmd>FzfLua lsp_definitions<CR>" {})
            (mkKeymap "n" "<leader>flr" "<cmd>FzfLua lsp_references<CR>" {})
            (mkKeymap "n" "<leader>flt" "<cmd>FzfLua lsp_typedefs<CR>" {})
            (mkKeymap "n" "<leader>flf" "<cmd>FzfLua lsp_finder<CR>" {})
            (mkKeymap "n" "<leader>fli" "<cmd>FzfLua lsp_implementations<CR>" {})
            (mkKeymap "n" "<leader>flci" "<cmd>FzfLua lsp_incoming_calls<CR>" {})
            (mkKeymap "n" "<leader>flco" "<cmd>FzfLua lsp_outgoing_calls<CR>" {})
            (mkKeymap "n" "<leader>flsd" "<cmd>FzfLua lsp_document_symbols<CR>" {})
            (mkKeymap "n" "<leader>flsl" "<cmd>FzfLua lsp_live_workspace_symbols<CR>" {})
            (mkKeymap "n" "<leader>flsw" "<cmd>FzfLua lsp_workspace_symbols<CR>" {})
            (mkKeymap "n" "<leader>flxd" "<cmd>FzfLua lsp_document_diagnostics<CR>" {})
            (mkKeymap "n" "<leader>flxw" "<cmd>FzfLua lsp_workspace_diagnostics<CR>" {})
            (mkKeymap "n" "<leader>flxx" "<cmd>FzfLua lsp_workspace_diagnostics<CR>" {})

            # DAP
            (mkKeymap "n" "<leader>fdb" "<cmd>FzfLua dap_breakpoints<CR>" {})
            (mkKeymap "n" "<leader>fdc" "<cmd>FzfLua dap_commands<CR>" {})
            (mkKeymap "n" "<leader>fdC" "<cmd>FzfLua dap_configurations<CR>" {})
            (mkKeymap "n" "<leader>fdf" "<cmd>FzfLua dap_frames<CR>" {})
            (mkKeymap "n" "<leader>fdv" "<cmd>FzfLua dap_variables<CR>" {})

            # QuickFix
            (mkKeymap "n" "<leader>fxx" "<cmd>FzfLua quickfix<CR>" {})
            (mkKeymap "n" "<leader>fxh" "<cmd>FzfLua quickfix_stack<CR>" {})
            (mkKeymap "n" "<leader>fxlx" "<cmd>FzfLua loclist<CR>" {})
            (mkKeymap "n" "<leader>fxlh" "<cmd>FzfLua loclist_stack<CR>" {})

            # Git
            (mkKeymap "n" "<leader>fgB" "<cmd>FzfLua git_blame<CR>" {})
            (mkKeymap "n" "<leader>fgb" "<cmd>FzfLua git_brances<CR>" {})
            (mkKeymap "n" "<leader>fgc" "<cmd>FzfLua git_commits<CR>" {})
            (mkKeymap "n" "<leader>fgC" "<cmd>FzfLua git_bcommits<CR>" {})
            (mkKeymap "n" "<leader>fgf" "<cmd>FzfLua git_files<CR>" {})
            (mkKeymap "n" "<leader>fgS" "<cmd>FzfLua git_stash<CR>" {})
            (mkKeymap "n" "<leader>fgs" "<cmd>FzfLua git_status<CR>" {})
            (mkKeymap "n" "<leader>fgt" "<cmd>FzfLua git_tags<CR>" {})
          ];
          cmd = "FzfLua";
        };
        nvim-treesitter-textobjects = let
          keymaps = {
            select = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
            };
            swap = {
              swap_next = {
                "cx;" = "@parameter.inner";
              };
              swap_previous = {
                "cx," = "@parameter.inner";
              };
            };
            move = {
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

          categoryToLznKeys = category: mode:
            flatten (mapAttrsToList (sectionName: section:
              mapAttrsToList (key: textObject: {
                inherit key mode;
                desc = "${sectionName} ${textObject}";
              })
              section)
            keymaps.${category});
        in {
          package = pkgs.vimPlugins.nvim-treesitter-textobjects;
          keys =
            categoryToLznKeys "swap" ["n"]
            ++ categoryToLznKeys "move" ["n" "o" "x"]
            ++ (mapAttrsToList (key: textObject: {
                inherit key;
                mode = ["x" "o"];
                desc = "Select ${textObject}";
              })
              keymaps.select);
          setupModule = "nvim-treesitter.configs";
          setupOpts = {
            textobjects = {
              select = {
                enable = true;
                lookahed = true;
                keymaps = keymaps.select;

                selection_modes = {
                  "@parameter.outer" = "v";
                  "@function.outer" = "V";
                  "@class.outer" = "V";
                };
              };
              swap = {enable = true;} // keymaps.swap;

              move =
                {
                  enable = true;
                  set_jumps = true;
                }
                // keymaps.move;
            };
          };
        };
      };
    };
  };

  vim.snippets.luasnip.enable = true;

  vim.lsp = {
    formatOnSave = true;
    lspkind.enable = false;
    lspsaga.enable = false;
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
        package = pkgs.clang-tools_19;
        server = "clangd";
      };
    };

    sql.enable = false;
    rust = {
      enable = false;
      crates.enable = true;
    };
    ts.enable = false;
    go.enable = true;
    zig.enable = false;
    python.enable = true;
    dart.enable = false;
    elixir.enable = false;
    php.enable = false;
    php.lsp.package = pkgs.phpactor.override {
      php = pkgs.php.buildEnv {extraConfig = "memory_limit = 8G";};
    };

    # "saying java is good because it runs on all systems is like saying
    # anal sex is good because it works on all species"
    # - sun tzu; translated by raf, probably
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
    nvim-web-devicons.enable = true;
    nvim-scrollbar.enable = true;
    fidget-nvim.enable = true;
  };

  vim.statusline = {
    lualine = {
      enable = true;
      setupOpts = {
        options.theme = "night-owl";
      };
    };
  };

  vim.theme.enable = false;

  # custom setup at the bottom
  vim.autopairs.nvim-autopairs.enable = false;

  vim.autocomplete.nvim-cmp = {
    enable = true;
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
    neo-tree = {
      enable = true;
      setupOpts = {
        git_status_async = true;
        window = {
          mapping_options = {nowait = false;};
          mappings = {
            "<space>" = "none";
            "l" = "open";
            "/" = "none";
            # "h" = {"@1" = "navigate_up";};
            "h" = mkLuaInline ''
              function()
                vim.cmd.normal "zcl";
              end
            '';
            "z" = "none";
            "zc" = "close_node";
            "zC" = "close_all_nodes";
            "s" = "open_split";
            "v" = "open_vsplit";
          };
        };
      };
    };
  };

  vim.tabline = {
    nvimBufferline.enable = false;
  };

  vim.treesitter = {
    fold = true;
    context = {
      enable = true;
      setupOpts = {
        max_lines = 5;
      };
    };
    mappings = {
      incrementalSelection = {
        init = "<M-o>";
        incrementByNode = "<M-o>";
        decrementByNode = "<M-i>";
      };
    };
  };

  vim.binds = {
    whichKey = {
      enable = true;
      register."s" = "+Surround";
    };
  };

  vim.telescope.enable = false;
  vim.telescope.setupOpts = {
    defaults.vimgrep_arguments = [
      "${pkgs.ripgrep}/bin/rg"
      "--color=never"
      "--no-heading"
      "--with-filename"
      "--line-number"
      "--column"
      "--smart-case"
      "--hidden"
    ];
  };

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
    borders = {
      enable = false;
      plugins = {
        nvim-cmp.style = "none";
      };
    };
    breadcrumbs.enable = false;
    illuminate.enable = true;
    fastaction.enable = true;
  };

  vim.assistant = {
    copilot = {
      enable = true;
      mappings = {
        panel = {
          jumpPrev = "<leader>ap";
          jumpNext = "<leader>an";
          accept = "<leader>ay";
          refresh = "<leader>ar";
          open = "<leader>ao";
        };
      };
    };
  };

  vim.session = {
    nvim-session-manager = {
      enable = true;
      setupOpts = {
        autoload_mode = "Disabled";
      };
    };
  };

  vim.comments.comment-nvim.enable = false;

  vim.mapTimeout = 200;

  vim.treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    markdown
    markdown-inline
    regex
  ];

  vim.luaConfigPre = ''
    vim.opt.runtimepath:prepend("${impurity.link ./config}");
    pcall(vim.cmd, [[
      call user#general#setup()
      call user#mapping#setup()
    ]])
  '';

  vim.luaConfigPost = ''
    vim.opt.wrap = false
    vim.g.default_terminal = 1
    vim.filetype.add({
      extension = {
        -- yuck = 'lisp',
      }
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

    -- LSP help window border
    local border = {"", "", "", "▕", "", "", "", "▌"}
    local orig = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contexts, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig(contexts, syntax, opts, ...)
    end
  '';

  vim.maps.normal = {
    # General
    "<leader>zf".action = ":lua vim.g.formatsave = not vim.g.formatsave<CR>";
    "<leader>e".action = ":Neotree toggle reveal<CR>";
    "<leader>ld".action = ":lua vim.diagnostic.setqflist({open = true})<CR>";
    "<leader>lf".action = ":lua vim.lsp.buf.format()<CR>";
    "<leader>li".action = ":lua vim.lsp.buf.implementation()<CR>";

    # Diffview
    "<leader>gdq".action = ":DiffviewClose<CR>";
    "<leader>gdd" = {
      action = ":DiffviewOpen ";
      silent = false;
    };
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

    # fzf-lua
    "<M-f>".action = ":FzfLua resume<CR>";
    "<leader>fq".action = ":FzfLua quickfix<CR>";
    "<leader>f/".action = ":FzfLua live_grep_native<CR>";
    "<leader>ff".action = ":FzfLua files<CR>";
    "<leader>fb".action = ":FzfLua buffers<CR>";
    "<leader>fh".action = ":FzfLua oldfiles<CR>";
    "<leader>f:".action = ":FzfLua command_history<CR>";

    # Aerial
    "gO".action = ":AerialToggle<CR>";

    # Image pasre
    "<leader>P".action = ":call mdip#MarkdownClipboardImage()<CR>";

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

  vim.maps.terminal = {
    "<M-x>".action = "<cmd>ToggleTerm<cr>";
    "<D-x>".action = "<cmd>ToggleTerm<cr>";
  };

  vim.keymaps = [
    # luasnip
    (mkKeymap ["n" "i" "s"] "<C-;>" "<Plug>luasnip-jump-next" {silent = true;})
    (mkKeymap ["n" "i" "s"] "<C-,>" "<Plug>luasnip-jump-prev" {silent = true;})
  ];

  vim.extraPlugins = with pkgs.vimPlugins; {
    night-owl-nvim = {
      package = night-owl-nvim;
      setup = "vim.cmd.colorscheme 'night-owl'";
    };
    treesitter-roc = {package = pkgs.neovim-treesitter-roc;};
    aerial = {
      package = aerial-nvim;
      setup = setup "aerial" {};
    };
    ssr-nvim = {
      package = pkgs.vimUtils.buildVimPlugin {
        pname = "ssr-nvim";
        version = "fork";
        src = inputs.ssr-nvim;
      };
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
    md-img-paste-vim = {
      package = pkgs.md-img-paste-vim;
      setup = ''
        vim.g.mdip_imgdir = "attachments"
      '';
    };
    nixrun = {package = pkgs.nixrun-nvim;};
  };
}
