{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  programs.hyprland = mkIf config.dots.wayland.enable {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
