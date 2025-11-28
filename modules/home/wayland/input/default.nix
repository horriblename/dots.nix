{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./touch.nix];
  config = lib.mkIf config.dots.wayland.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          qt6Packages.fcitx5-configtool
        ];
      };
    };
  };
}
