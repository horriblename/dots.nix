{impurity, ...}: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".source = impurity.link ./config.kdl;
}
