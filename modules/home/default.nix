{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.py = {
    home.username = user;
    home.homeDirectory = "/home/${user}";

    imports = [
      ./apps.nix
      ./hyprland
      ./packages.nix
      ./eww
      ./dunst
      ./foot
      ./tofi
      ./shell
      ./lf
      ./lisgd # touchscreen gestures
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-treesitter.withPlugins
      (p: [ p.c p.nix ])
    ];

    home.stateVersion = "22.11";
    programs.home-manager.enable = true;
  };
}
