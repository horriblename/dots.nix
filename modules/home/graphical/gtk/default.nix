{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      size = 13;
    };
    theme = {
      name = "Kanagawa-BL";
      package = pkgs.kanagawa-gtk;
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Dark-Cursors";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  # credits: bruhvko
  # catppuccin theme for qt-apps
  home.packages = with pkgs; [libsForQt5.qtstyleplugin-kvantum];
  home.sessionVariables = {
    # this is "not recommended" but I'm too lazy to care anymore
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Rosewater/Catppuccin-Mocha-Rosewater.kvconfig";
    sha256 = "sha256:0rzlg03wf57js1kaf1hhrl44nrawy48nx7d21bacyq0ai1r8mvwk";
  };
  xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Rosewater/Catppuccin-Mocha-Rosewater.svg";
    sha256 = "sha256:08ankdfcnic4374d3kiqllqyzryn07iahxp72wk9f5q5zxy76gdq";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin

    [Applications]
    catppuccin=Dolphin, dolphin, Nextcloud, nextcloud, qt5ct, org.kde.dolphin, org.kde.kalendar, kalendar, Kalendar
  '';
}
