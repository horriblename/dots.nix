{
  symlinkJoin,
  runCommand,
  neovimUtils,
  treesitter-roc,
  treesitter-roc-src,
}: let
  wrapped-parser = neovimUtils.grammarToPlugin treesitter-roc;
  scripts = runCommand "neovim-treesitter-roc-scripts" {} ''
    mkdir -p $out/after
    mkdir -p $out/plugin
    cp ${treesitter-roc-src}/neovim/roc.lua $out/plugin
    cp -r ${treesitter-roc-src}/neovim/queries $out/after
  '';
in
  symlinkJoin {
    name = "neovim-treesitter-roc";
    paths = [
      wrapped-parser
      scripts
    ];
  }
