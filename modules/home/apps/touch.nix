{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.touchScreen {
    home.packages = [
      pkgs.epiphany
    ];
  };
}
