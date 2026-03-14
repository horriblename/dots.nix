{
  inputs,
  lib,
  config,
  pkgs,
  impurity,
  pins,
  ...
}: let
  nix2Lua = inputs.nvf.lib.nvim.lua.toLuaObject;
  inherit (inputs.nvf.lib.nvim.dag) entryBetween;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.modules) mkForce mkIf;
  devEnabled = config.dots.development.enable;
  langCfg = config.programs.nvf.settings.vim.languages;
  setup = module: table: "require('${module}').setup(${nix2Lua table})";
  mkKeymap = mode: key: action: opts:
    {
      inherit mode key action;
      noremap = true;
      silent = true;
    }
    // opts;
  noBuildPlug = pname: let
    pin = pins.${pname};
    version = builtins.substring 0 8 pin.revision;
  in
    pin.outPath.overrideAttrs {
      inherit pname version;
      name = "${pname}-${version}";

      passthru.vimPlugin = false;
    };
in {
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = false;
    preventJunkFiles = true;
    enableLuaLoader = true;

    options = {
      signcolumn = "yes:2";
    };

    lazy = {
      enable = true;
      plugins = {
        cfilter = {
          package = null;
          cmd = ["Cfilter"];
          load = "vim.cmd.packadd(name)";
        };
        undotree = {
          package = pkgs.vimPlugins.undotree;
          before = ''
            vim.g.undotree_ShortIndicators = true
            vim.g.undotree_TreeVertShape = '│'
            vim.g.undotree_DiffCommand = [[sh -c 'git diff --word-diff --word-diff-regex="[^\n]" --no-index "$@" | tail -n +5' git]]
            vim.g.undotree_CustomMap = function()
              vim.wo.winfixwidth = true
              vim.wo.winfixheight = true
            end
            vim.g.undotree_CustomDiffpanelCmd = [[botright 12 new +setl\ winfixheight\ winfixwidth]]
          '';
          cmd = ["UndotreeFocus" "UndotreeHide" "UndotreePersistUndo" "UndotreeShow" "UndotreeToggle"];
          keys = [
            (mkKeymap "n" "<leader>u" ":UndotreeToggle<CR>" {})
          ];
        };
        perfanno-nvim = {
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "perfanno-nvim";
            version = "git";
            src = inputs.perfanno-nvim;
            nvimSkipModules = ["perfanno.fzf_lua"];
          };
          setupModule = "perfanno";
          setupOpts = {};
          cmd = [
            "PerfAnnotate"
            "PerfAnnotateFunction"
            "PerfAnnotateSelection"
            "PerfCacheDelete"
            "PerfCacheLoad"
            "PerfCacheSave"
            "PerfCycleFormat"
            "PerfHottestCallersFunction"
            "PerfHottestCallersSelection"
            "PerfHottestLines"
            "PerfHottestSymbols"
            "PerfLoadCallGraph"
            "PerfLoadFlameGraph"
            "PerfLoadFlat"
            "PerfLuaProfileStart"
            "PerfLuaProfileStop"
            "PerfPickEvent"
            "PerfToggleAnnotations"
          ];
          keys = [
            (mkKeymap "n" "<leader>plf" ":PerfLoadFlat<CR>" {desc = "Load Flat";})
            (mkKeymap "n" "<leader>plg" ":PerfLoadCallGraph<CR>" {desc = "Load Call Graph";})
            (mkKeymap "n" "<leader>plo" ":PerfLoadFlameGraph<CR>" {desc = "Load Flame Graph";})

            (mkKeymap "n" "<leader>pe" ":PerfPickEvent<CR>" {desc = "Pick Event";})

            (mkKeymap "n" "<leader>pa" ":PerfAnnotate<CR>" {desc = "Annotate";})
            (mkKeymap "n" "<leader>pf" ":PerfAnnotateFunction<CR>" {desc = "Annotate Function";})
            (mkKeymap "x" "<leader>pa" ":PerfAnnotateSelection<CR>" {desc = "Annotate Selection";})

            (mkKeymap "n" "<leader>pt" ":PerfToggleAnnotations<CR>" {desc = "Toggle Annotations";})

            (mkKeymap "n" "<leader>ph" ":PerfHottestLines<CR>" {desc = "Hottest Lines";})
            (mkKeymap "n" "<leader>ps" ":PerfHottestSymbols<CR>" {desc = "Hottest Symbols";})
            (mkKeymap "n" "<leader>pc" ":PerfHottestCallersFunction<CR>" {desc = "Hottest Callers Function";})
            (mkKeymap "x" "<leader>pc" ":PerfHottestCallersSelection<CR>" {desc = "Hottest Callers Selection";})
          ];
        };
        "grug-far.nvim" = {
          package = noBuildPlug "grug-far.nvim";
          cmd = ["GrugFar"];
          setupModule = "grug-far";
          setupOpts = {
            engines = {
              astgrep = {
                path = "${pkgs.ast-grep}/bin/ast-grep";
              };
            };
            engine = "astgrep";
          };
          after = ''
            vim.api.nvim_create_autocmd('FileType', {
              group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
              pattern = { 'grug-far' },
              callback = function()
                vim.bo.buftype = "nofile"
                vim.bo.bufhidden = "delete"
              end,
            })
          '';
        };
        "asyncrun.vim" = {
          package = pkgs.vimPlugins.asyncrun-vim;
          cmd = ["AsyncRun"];
          keys = [
            (mkKeymap "n" "<leader>mm" "':AsyncRun ' . (exists('g:runner_cmd') ? g:runner_cmd . '<CR>' : '')" {
              desc = "AsyncRun";
              expr = true;
              silent = false;
            })
          ];
        };
        "iron.nvim" = {
          package = pkgs.vimPlugins.iron-nvim;
          setupModule = "iron";
          setupOpts = {
            config = {
              repl_open_cmd = mkLuaInline "require('iron.view').split.botright(16)";
            };

            repl_definition = {
              nix = {
                command = ["nix" "repl" "nixpkgs"];
              };
            };

            keymaps = {
              toggle_repl = "<leader>rr";
              restart_repl = "<leader>rR";
              send_motion = "<leader>rs";
              visual_send = "<leader>rs";
              send_file = "<leader>rf";
              send_line = "<leader>rss";
              send_mark = "<leader>r'";
              send_code_block = "<leader>rb";
              send_code_block_and_move = "<leader>rn";
              mark_motion = "<leader>rm";
              mark_visual = "<leader>rm";
              remove_mark = "<leader>rM";
              cr = "<leader>r<cr>";
              interrupt = "<leader>ri";
              exit = "<leader>rq";
              clear = "<leader>r<C-l>";
            };
          };
        };
      };
    };

    augroups =
      map (name: {
        inherit name;
        clear = true;
      }) [
        "dots_term_block_illuminate"
        "dots_minifiles"
      ];
    autocmds = [
      {
        desc = "Block vim-illuminate in terminal";
        event = ["TermOpen"];
        command = "IlluminatePauseBuf";
        group = "dots_term_block_illuminate";
      }
      {
        desc = "Custom mini.files keymaps";
        event = ["FileType"];
        pattern = ["minifiles"];
        callback = mkLuaInline ''
          function()
            local function cdToGitRoot()
              local state = MiniFiles.get_explorer_state()
              if state == nil then
                vim.notify("Tried to cdToGitRoot when mini.files is not open?", vim.log.levels.ERROR)
              end
              local res = vim.system(
                {"git", "-C", state.branch[state.depth_focus], "rev-parse", "--show-toplevel"},
                {text = true}
              ):wait()
              if res.code == 0 then
                MiniFiles.set_branch({vim.trim(res.stdout)})
              else
                local msg = "Could not find git root directory:\n" .. res.stderr
                vim.notify(msg, vim.log.levels.ERROR)
              end
            end
            vim.keymap.set("n", "g0", cdToGitRoot, {
              buffer = true,
              desc = "Go to Git Root",
            })
          end
        '';
      }
    ];

    snippets.luasnip = {
      enable = true;
      loaders = ''
        require('luasnip.loaders.from_vscode').lazy_load()
        require('luasnip.loaders.from_vscode').lazy_load({paths = {"~/.config/nvim/snippets"}})
      '';
    };

    lsp = {
      enable = devEnabled;
      formatOnSave = true;
      lspsaga.enable = false;
      lspconfig.enable = true;
      lspSignature.enable = false;
      mappings.openDiagnosticFloat = null;
      harper-ls.enable = devEnabled;
    };

    debugger.nvim-dap = {
      ui.enable = true;
    };

    languages = {
      enableDAP = devEnabled;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      clang.enable = true;
      dart.enable = false;
      elixir.enable = false;
      go.enable = true;
      haskell = {
        enable = true;
        lsp.enable = false;
        dap.enable = false;
      };
      html.enable = true;
      lua = {
        enable = true;
        lsp.lazydev.enable = false;
        format.enable = false;
      };
      markdown = {
        enable = true;
      };
      nix = {
        enable = true;
        lsp.servers = ["nixd"];
      };
      php.enable = false;
      python.enable = true;
      rust = {
        enable = false;
      };
      sql.enable = false;
      ts.enable = false;
      zig.enable = false;
    };

    lsp.servers = {
      clangd.cmd =
        mkIf langCfg.clang.lsp.enable
        (lib.mkForce ["${pkgs.llvmPackages_19.clang-tools}/bin/clangd"]);
      clojure_lsp = {};
      elmls = {};
      jdtls = {
        enable = false;
        cmd = ["jdt-language-server" "-configuration" "${config.xdg.cacheHome}/jdtls/config" "-data" "${config.xdg.cacheHome}/jdtls/workspace"];
      };
      lua-language-server = {
        settings.Lua = {
          runtime.version = "LuaJIT";
          workspace.library = ["lua" "\${env:VIMRUNTIME}"];
          diagnostic.globals = ["vim"];
        };
      };
      nil = {
        settings.nil.nix.flake.autoArchive = false;
      };
      nixd = mkIf langCfg.nix.lsp.enable {
        cmd = mkForce [(lib.getExe pkgs.nixd) "--log=error"];
      };
      roc_ls = {
        cmd = ["roc_language_server"];
        filetypes = ["roc"];
        root_markers = [".git" "main.roc"];
      };
      yamlls = {};
    };

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-scrollbar.enable = true;
      fidget-nvim.enable = true;
    };

    theme.enable = false;

    # custom setup at the bottom
    autopairs.nvim-autopairs.enable = false;

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        sources = {
          providers = {
            # copilot.score_offset = -20;
            buffer.score_offset = -30;
          };
        };

        signature = {
          enabled = true;
          window.border = ["" "" "" "▕" "" "" "" "▌"];
        };
        completion.documentation = {
          window.border = ["" "" "" "▕" "" "" "" "▌"];
        };
        appearance = {
          kind_icons = {
            Variable = "󰀫";
            Class = "";
            Interface = "";
            Struct = "";
            Unit = "󰑭";
            Value = "󰎠";
            Enum = "";
            EnumMember = "";
            Keyword = "󰌋";
            Snippet = "󰩫";
            Operator = "󰆕";
            TypeParameter = "T";
          };
        };
        cmdline.keymap = mkForce {};
      };
      mappings = {
        complete = "<C-x><C-a>";
        close = "<C-e>";
        confirm = "<C-y>";
        next = "<C-n>";
        previous = "<C-p>";
        scrollDocsDown = "<C-j>";
        scrollDocsUp = "<C-k>";
      };
    };

    tabline = {
      nvimBufferline.enable = false;
    };

    treesitter = {
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

    binds = {
      whichKey = {
        enable = false;
      };
    };

    telescope.enable = false;
    telescope.setupOpts = {
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

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        setupOpts = {
          sign_priority = 50;
        };
        codeActions.enable = false;
      };
    };

    dashboard = {
      dashboard-nvim = {
        enable = false;
        setupOpts = {
          # adapted from nvf logo (https://github.com/NotAShelf/nvf)
          # under CC-BY (https://creativecommons.org/licenses/by/4.0/)
          config.header = [
            "   🭇🭄🭏🬼          🬿    "
            "  🭊🭁██🭌🬿         █🭏🬼  "
            "  🭥🭒████🭏🬼       ██🭌🬿 "
            "λ  🭢🭕████🭌🬿      ████🭏"
            "VλV  🭥🭒████🭏🬼    █████"
            "λVλVλ 🭢🭕████🭌🬿   █████"
            "VλV󱄅    🭥🭒████🭏🬼 🭕████"
            "λVλVλ    🭢🭕████🭌🬿 🭥🭒██"
            "V󱄅 λV      🭥🭒████🭏🬼🭢🭕🭠"
            "λVλVλ       🭢🭕████🭌🬿  "
            "  VλV         🭥🭒██🭝🭚  "
            "    λ          🭢🭕🭠🭗   "
            ""
          ];
        };
      };
    };

    spellcheck = {
      enable = true;
      languages = ["en" "de_de"];
      ignoredFiletypes = ["qf"];
      programmingWordlist.enable = true;
    };

    utility = {
      diffview-nvim.enable = true;
      snacks-nvim = {
        enable = true;
        setupOpts = {
          bigfile = {
            enable = true;
          };
        };
      };
      vim-wakatime = {
        enable = true;
      };
    };

    mini = {
      files = {
        enable = true;
        setupOpts = {
          mappings = {
            go_in = "L";
            go_in_plus = "l";
            synchronize = "<C-s>";
          };
          windows = {
            max_number = 3;
            preview = false;
          };
        };
      };

      clue = {
        enable = true;
        setupOpts = {
          triggers = let
            mkTrigger = mode: keys: {inherit mode keys;};
          in [
            # Leader triggers
            (mkTrigger "n" "<Leader>")
            (mkTrigger "x" "<Leader>")

            # Built-in completion
            (mkTrigger "i" "<C-x>")

            # `g` key
            (mkTrigger "n" "g")
            (mkTrigger "x" "g")

            # Marks
            (mkTrigger "n" "\"")
            (mkTrigger "n" "`")
            (mkTrigger "x" "\"")
            (mkTrigger "x" "`")

            # Registers
            (mkTrigger "n" "\"")
            (mkTrigger "x" "\"")
            (mkTrigger "i" "<C-r>")
            (mkTrigger "c" "<C-r>")

            # Window commands
            (mkTrigger "n" "<C-w>")

            # `z` key
            (mkTrigger "n" "z")
            (mkTrigger "x" "z")
          ];

          window = {
            config = {
              width = 40;
            };
            delay = mkLuaInline "vim.o.timeoutlen";
          };
          clues = mkLuaInline ''
            (function(miniclue)
              return {
                miniclue.gen_clues.square_brackets(),
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers({show_contents = true}),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
              }
            end)(require("mini.clue"))
          '';
        };
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    ui = {
      borders = {
        enable = false;
        plugins = {
          nvim-cmp.style = "none";
        };
      };
      breadcrumbs.enable = false;
      illuminate = {
        enable = true;
        setupOpts = {
          large_file_cutoff = 2000;
          large_file_overrides = {
            providers = [];
          };
        };
      };
    };

    assistant = {
      copilot = {
        enable = false;
        cmp.enable = true;
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

    comments.comment-nvim.enable = false;

    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      markdown
      markdown-inline
      regex
    ];

    luaConfigPre = ''
      vim.opt.runtimepath:prepend("${impurity.link ./config}");
    '';

    luaConfigRC.userDots = entryBetween ["lazyConfigs"] ["optionsScript"] ''
      pcall(vim.cmd, [[
        call user#general#setup()
        call user#mapping#setup()
      ]])
    '';

    luaConfigPost = ''
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
      vim.cmd.highlight("default", "link", "DashboardHeader", "DevIconNix")

      -- LSP help window border
      local border = {"", "", "", "▕", "", "", "", "▌"}
      local orig = vim.lsp.util.open_floating_preview
      vim.lsp.util.open_floating_preview = function(contexts, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig(contexts, syntax, opts, ...)
      end

      local lspconfig = require("lspconfig")
      lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
        if config.on_attach == nil then
          config.on_attach = default_on_attach
        end
      end)
    '';

    keymaps = [
      # General
      (mkKeymap "n" "<leader>zf" ":lua vim.g.formatsave = not vim.g.formatsave<CR>" {})
      (mkKeymap "n" "<leader>ld" ":lua vim.diagnostic.setqflist({open = true})<CR>" {})
      (mkKeymap "n" "<leader>lf" ":lua vim.lsp.buf.format()<CR>" {})
      (mkKeymap "n" "<leader>li" ":lua vim.lsp.buf.implementation()<CR>" {})
      (mkKeymap "n" "<leader>le"
        "<cmd>lua vim.diagnostic.config({virtual_lines = not vim.diagnostic.config().virtual_lines})<CR>"
        {desc = "Toggle line diagnostics";})

      # Diffview
      (mkKeymap "n" "<leader>gdq" ":DiffviewClose<CR>" {})
      (mkKeymap "n" "<leader>gdd" ":DiffviewOpen" {silent = false;})
      (mkKeymap "n" "<leader>gdm" ":DiffviewOpen<CR>" {})
      (mkKeymap "n" "<leader>gdh" ":DiffviewFileHistory %<CR>" {})
      (mkKeymap "n" "<leader>gde" ":DiffviewToggleFiles<CR>" {})

      # Git
      (mkKeymap "n" "<leader>gu" "<cmd>Gitsigns undo_stage_hunk<CR>" {})
      (mkKeymap "n" "<leader>g<C-w>" "<cmd>Gitsigns preview_hunk<CR>" {})
      (mkKeymap "n" "<leader>gp" "<cmd>Gitsigns prev_hunk<CR>" {})
      (mkKeymap "n" "<leader>gn" "<cmd>Gitsigns next_hunk<CR>" {})
      (mkKeymap "n" "<leader>gP" "<cmd>Gitsigns preview_hunk_inline<CR>" {})
      (mkKeymap "n" "<leader>gR" "<cmd>Gitsigns reset_buffer<CR>" {})
      (mkKeymap "n" "<leader>gb" "<cmd>Gitsigns blame_line<CR>" {})
      (mkKeymap "n" "<leader>gD" "<cmd>Gitsigns diffthis HEAD<CR>" {})
      (mkKeymap "n" "<leader>gw" "<cmd>Gitsigns toggle_word_diff<CR>" {})
      (mkKeymap "n" "]g" ":Gitsigns next_hunk<CR>" {})
      (mkKeymap "n" "[g" ":Gitsigns prev_hunk<CR>" {})

      # fzf-lua
      (mkKeymap "n" "<M-f>" ":FzfLua resume<CR>" {})
      (mkKeymap "n" "<leader>fq" ":FzfLua quickfix<CR>" {})
      (mkKeymap "n" "<leader>f/" ":FzfLua live_grep_native<CR>" {})
      (mkKeymap "n" "<leader>ff" ":FzfLua files<CR>" {})
      (mkKeymap "n" "<leader>fb" ":lua FzfLua.buffers{previewer = 'builtin'}<CR>" {})
      (mkKeymap "n" "<leader>fh" ":FzfLua oldfiles<CR>" {})
      (mkKeymap "n" "<leader>f:" ":FzfLua command_history<CR>" {})
      (mkKeymap "n" "<leader>f]" ":FzfLua tags<CR>" {})
      (mkKeymap "n" "g]" ":ltag <C-R><C-W> | lua FzfLua.loclist{previewer = 'builtin'}<CR>" {})

      # Aerial
      (mkKeymap "n" "gO" ":AerialToggle<CR>" {})

      # Image pasre
      (mkKeymap "n" "<leader>P" ":call mdip#MarkdownClipboardImage()<CR>" {})

      # luasnip
      (mkKeymap ["n" "i" "s"] "<C-;>" "<Plug>luasnip-jump-next" {silent = true;})
      (mkKeymap ["n" "i" "s"] "<C-,>" "<Plug>luasnip-jump-prev" {silent = true;})

      (mkKeymap ["n" "x" "o"] "<leader>gs" ":Gitsigns stage_hunk<CR>" {})
      (mkKeymap ["n" "x" "o"] "<leader>gr" ":Gitsigns reset_hunk<CR>" {})
      (mkKeymap ["n" "x" "o"] "<leader>lr" "<cmd>lua vim.lsp.buf.references()<CR>" {})

      # FzfLua
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
      (mkKeymap "n" "<leader>de" "function() require('dap').set_exception_breakpoints() end" {
        lua = true;
      })

      # QuickFix
      (mkKeymap "n" "<leader>fxx" "<cmd>FzfLua quickfix<CR>" {})
      (mkKeymap "n" "<leader>fxh" "<cmd>FzfLua quickfix_stack<CR>" {})
      (mkKeymap "n" "<leader>fxlx" "<cmd>FzfLua loclist<CR>" {})
      (mkKeymap "n" "<leader>fxlh" "<cmd>FzfLua loclist_stack<CR>" {})

      # Git
      (mkKeymap "n" "<leader>fgB" "<cmd>FzfLua git_blame<CR>" {})
      (mkKeymap "n" "<leader>fgb" "<cmd>FzfLua git_branches<CR>" {})
      (mkKeymap "n" "<leader>fgc" "<cmd>FzfLua git_commits<CR>" {})
      (mkKeymap "n" "<leader>fgC" "<cmd>FzfLua git_bcommits<CR>" {})
      (mkKeymap "n" "<leader>fgf" "<cmd>FzfLua git_files<CR>" {})
      (mkKeymap "n" "<leader>fgS" "<cmd>FzfLua git_stash<CR>" {})
      (mkKeymap "n" "<leader>fgs" "<cmd>FzfLua git_status<CR>" {})
      (mkKeymap "n" "<leader>fgt" "<cmd>FzfLua git_tags<CR>" {})
      (mkKeymap "n" "]g" ":Gitsigns next_hunk<CR>" {})
      (mkKeymap "n" "[g" ":Gitsigns prev_hunk<CR>" {})

      # mini.files
      (mkKeymap "n" "-" ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>" {
        desc = "Open mini.files in the parent of this buffer";
      })
      (mkKeymap "n" "<leader>e" ":lua MiniFiles.open(MiniFiles.get_latest_path())<CR>" {
        desc = "Open mini.files in last opened path";
      })

      # 99
      (mkKeymap "n" "<leader>9f" "require('99').fill_in_function" {
        lua = true;
        desc = "Fill in function";
      })
      (mkKeymap "x" "<leader>9v" "require('99').visual" {lua = true;})
      (mkKeymap "x" "<leader>9s" "require('99').stop_all_requests" {
        lua = true;
        desc = "Stop all requests";
      })
    ];

    extraPlugins = with pkgs.vimPlugins; {
      night-owl-nvim = {
        package = night-owl-nvim;
        setup = ''
          do
            local group = vim.api.nvim_create_augroup("night-owl-tweaks", {clear = true})
            vim.api.nvim_create_autocmd("Colorscheme", {
              pattern = {"night-owl"},
              group = group,
              command = [[
                hi WinSeparator guifg=smokewhite
                hi CurSearch guibg=Orange guifg=NvimDarkGray1
                hi IncSearch guibg=NvimLightYellow guifg=NvimDarkGray1
                hi NonText gui=nocombine
                hi DiffAdd        guifg=NONE guibg=#123a2f
                hi DiffDelete     guifg=NONE guibg=#3a1618
                hi DiffChange     guifg=NONE guibg=#3a2f12
                hi DiffText       ctermfg=0 ctermbg=14 guifg=NONE guibg=#6b4e1d
                hi SpellBad       gui=underdotted guisp=Red
                hi SpellCap       gui=underdotted guisp=Yellow
                hi SpellRare      gui=underdotted guisp=LightBlue
                hi SpellLocal     gui=underdotted guisp=SlateBlue
                hi WinSeparator guifg=smokewhite
              ]]
            })
          end
          vim.cmd.colorscheme("night-owl")
        '';
      };
      treesitter-roc = {package = pkgs.neovim-treesitter-roc;};
      aerial = {
        package = noBuildPlug "aerial.nvim";
        setup = setup "aerial" {};
      };
      luee = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "luee";
          version = "git";
          src = inputs.luee;
        };
      };
      fzf-lua = {
        package = "fzf-lua";
        setup =
          setup "fzf-lua" {
            "@1" = "max-perf";
            keymap = {
              builtin = {
                "@1" = true;
                "ctrl-j" = "preview-page-down";
                "ctrl-k" = "preview-page-up";
              };
              fzf = {
                "@1" = true;
                "ctrl-j" = "preview-page-down";
                "ctrl-k" = "preview-page-up";
              };
            };
            previewers = {
              bat.args = "--color=always --style=numbers,changes --decorations=always";
            };
            buffers.previewers = "builtin";
            winopts.on_create = mkLuaInline ''
              function()
                local function expander(expr)
                  return function()
                    local winid = vim.fn.win_getid(vim.fn.winnr("#"))
                    return vim.api.nvim_win_call(winid, function()
                      return vim.fn.expand(expr)
                    end)
                  end
                end

                local opt = {expr = true, silent = true, remap = false, buffer = true}
                vim.keymap.set("t", "<c-r><c-w>", expander("<cword>"), opt)
                vim.keymap.set("t", "<c-r>%", expander("%"), opt)
              end
            '';
          }
          + ''
            require('fzf-lua').register_ui_select()
          '';
      };
      "99" = {
        package = noBuildPlug "99";
        setup = setup "99" {
          completion = {
            custom_rules = ["scratch/rules/"];
            source = "cmp";
          };
        };
      };
      friendly-snippets = {package = friendly-snippets;};
      direnv = {package = direnv-vim;};
      nvim-autopairs = {
        package = "nvim-autopairs";
        setup = setup "nvim-autopairs" {
          check_ts = true;
          disable_filetype = ["TelescopePrompt"];
          enable_afterquote = false;
        };
      };
      md-img-paste-vim = {
        package = pkgs.md-img-paste-vim;
        setup = ''
          vim.g.mdip_imgdir = "attachments"
        '';
      };
      nixrun = {package = pkgs.nixrun-nvim;};
      nvim-treesitter-textobjects = {
        package = pkgs.vimPlugins.nvim-treesitter-textobjects;
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
              };
              goto_previous_start = {
                "[f" = "@function.outer";
                "[C" = "@class.outer";
              };
              goto_next_end = {
                "]F" = "@function.outer";
              };
              goto_previous_end = {
                "[F" = "@function.outer";
                "]C" = "@class.outer";
              };
            };
          };
        };
      };
    };
  };
}
