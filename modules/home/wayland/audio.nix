{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  services.easyeffects = mkIf config.dots.wayland.enable {
    enable = true;
  };
}
