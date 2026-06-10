{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.dots.wayland.enable {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    platformTheme.package = [
      pkgs.kdePackages.qt6ct
    ];

    # using style.name sets QT_STYLE_OVERRIDE, which qt6ct warns against
    # and straight up breaks opencloud
    style.package = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.qt6Packages.qtstyleplugin-kvantum
      pkgs.kdePackages.breeze-icons
    ];
  };

  xdg.configFile = {
    # "qt6ct/qt6ct.conf".source = ./qt6ct.conf;
  };
}
