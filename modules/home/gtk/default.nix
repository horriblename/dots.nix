{ self
, pkgs
, config
, inputs
, ...
}:
let
  # gruvterial = (pkgs.gruvterial-theme.overrideAttrs (oldAttrs: {
  #   THEME_VARIANT = "dark";
  #   # THEME_LAPTOP_MODE = "true";
  # }));
  amarena = pkgs.gruvterial-theme.override {
    theme = "amarena";
  };
in
{
  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      size = 13;
    };
    # theme.package = pkgs.colloid-gtk-theme;
    # theme.name = "Colloid-Dark";
    theme.package = amarena;
    theme.name = "amarena";
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

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  # cursor theme
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaRosewater;
    name = "Catppuccin-Mocha-Rosewater";
    size = 16;
  };
  home.pointerCursor.gtk.enable = true;
}
