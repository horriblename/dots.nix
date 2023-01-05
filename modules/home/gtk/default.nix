{ self
, pkgs
, config
, inputs
, ...
}: {
  gtk = {
    enable = true;
    font = {
      name = "Lato";
      size = 13;
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };

  # TODO package GoogleDots cursor theme
  # cursor theme
  # home.pointerCursor = {
  #   package = self.packages.${pkgs.system}.catppuccin-cursors;
  #   name = "Catppuccin-Frappe-Dark";
  #   size = 16;
  # };
  # home.pointerCursor.gtk.enable = true;
}
