{impurity, ...}: {
  xdg.configFile."xdg-desktop-portal/niri-portals.conf".source =
    impurity.link ./niri-portals.conf;
  xdg.configFile."niri/config.kdl".source =
    impurity.link ./config.kdl;
}
