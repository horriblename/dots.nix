{pkgs, ...}: {
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
}
