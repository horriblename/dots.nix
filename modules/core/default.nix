{ pkgs, config, ... }:
{
  nix.extraOptions = "experimental-features = nix-command flakes";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = builtins.readFile ../../pkgs/config.vim;
    };
  };
}
