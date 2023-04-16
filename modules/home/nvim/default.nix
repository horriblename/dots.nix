{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  xdg.configFile."nvim".source = ./config;
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      undotree
      # (p: [ p.c p.nix ])
    ];
  };
}
