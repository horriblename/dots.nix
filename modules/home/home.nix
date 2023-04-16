{
  self,
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "py";
  home.homeDirectory = "/home/py";

  imports = [
    ./apps.nix
    ./sway
    ./hyprland
    ./packages.nix
    ./gtk
    ./eww
    # ./helix
    ./nvim
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

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
