{lib, ...}:
with lib; let
  plugin-spec = types.submodule {
    options = {
      package = mkOption {
        type = with types; either package str;
        description = "Package to use";
      };
      loadOnStart = mkOption {
        type = types.bool;
        description = "Whether to load this plugin on start";
        default = true;
      };
      setup = mkOption {
        type = types.str;
        description = "The lua code to run during setup, usually `require(module).setup {...}`";
        default = "";
        example = ''
          require('aerial').setup({
            on_attach = function(bufnr)
              vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
              vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
            end
          })
        '';
      };
    };
  };
in {
  options.vim.extraPlugins = mkOption {
    type = types.listOf plugin-spec;
    description = "List of extra plugins to load";
  };
}
