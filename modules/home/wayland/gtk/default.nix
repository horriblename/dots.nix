{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
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
      iconTheme = {
        name = "Kanagawa";
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
    home = {
      pointerCursor = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 16;
        gtk.enable = true;
      };
    };
  };
}
