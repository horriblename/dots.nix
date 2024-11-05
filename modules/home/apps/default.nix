{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.graphicalApps {
    home.packages = [
      pkgs.firefox
    ];
  };
}
