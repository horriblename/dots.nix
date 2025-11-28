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
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.fira-code
    ];
  };
}
