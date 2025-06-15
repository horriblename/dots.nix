{
  config,
  lib,
  self,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.touchScreen {
    home.packages = [
      self.packages.${pkgs.system}.styluslabs-write
    ];
  };
}
