{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      lato
      lexend
      material-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];
  };
}
