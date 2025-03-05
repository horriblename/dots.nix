{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.graphicalApps {
    home.packages = with pkgs; [
      firefox
      kdePackages.okular
      image-roll
    ];
  };
}
