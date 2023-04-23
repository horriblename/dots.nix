{...}: {
  home.username = "py";
  home.homeDirectory = "/home/py";
  xdg.enable = true;
  imports = [
    ./module.nix
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
