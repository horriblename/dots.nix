{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./touch.nix];
  config = lib.mkIf config.dots.wayland.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-configtool
      ];
    };
  };
}
