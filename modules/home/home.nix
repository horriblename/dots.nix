{
  lib,
  inputs,
  self,
  ...
}: {
  home.username = lib.mkDefault "py";
  home.homeDirectory = lib.mkDefault "/home/py";
  nix.settings.nix-path = ["nixpkgs=${inputs.nixpkgs}" "dots=${self}"];
  xdg.enable = true;
  imports = [
    ./module.nix
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
