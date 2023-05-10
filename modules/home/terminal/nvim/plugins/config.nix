{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.vim;
  nvim-lib = inputs.neovim-flake.lib.nvim;
  startPluginSpecs = builtins.filter (x: x.loadOnStart) cfg.extraPlugins;
in {
  config.programs.neovim-flake.settings.vim = lib.mkIf ((builtins.length startPluginSpecs) != 0) {
    startPlugins = map (plugSpec: plugSpec.package) startPluginSpecs;

    luaConfigRC.extraPlugins = nvim-lib.dag.entryAnywhere (
      builtins.concatStringsSep "\n"
      (map (plugSpec: plugSpec.setup) startPluginSpecs)
    );
  };
}
