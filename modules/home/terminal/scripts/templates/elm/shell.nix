{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; with elmPackages; [elm elm-language-server elm-format elm-test];
  VIM_EXTRA_PATH = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; with pkgs.neovimUtils; "${grammarToPlugin elm}";
}
