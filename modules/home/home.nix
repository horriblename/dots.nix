{lib, ...}: {
  home.username = lib.mkDefault "py";
  home.homeDirectory = lib.mkDefault "/home/py";
  xdg.enable = true;
  imports = [
    ./module.nix
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
