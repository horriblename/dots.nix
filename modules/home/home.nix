{ config, pkgs, inputs, ... }:

{
  home.username = "py";
  home.homeDirectory = "/home/py";

  imports = [
    ./apps.nix
    ./sway
    ./hyprland
    ./packages.nix
    ./gtk
    ./eww
    ./helix
    ./dunst
    ./foot
    ./tofi
    ./shell
    ./lf
    ./swayidle
    ./lisgd # touchscreen gestures
    ./fonts.nix
  ];

  xdg.enable = true;

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-nix
    nvim-treesitter.withPlugins
    (p: [ p.c p.nix ])
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
