{
  lib,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  cfgPreset = config.dots.preset;
in {
  config = mkMerge [
    (mkIf (cfgPreset == "archbox") {dots.wayland.enable = true;})
    (mkIf (cfgPreset == "surface") {
      dots.wayland = {
        enable = true;
        touchScreen = true;
      };
    })
    (mkIf (cfgPreset == "darwin-work") {dots.darwin.enable = true;})
  ];
}
