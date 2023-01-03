{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home.username = ${user};
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;
}
