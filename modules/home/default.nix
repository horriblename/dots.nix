{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.py = import ./home.nix;
}
