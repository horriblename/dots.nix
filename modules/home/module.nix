{
  lib,
  config,
  inputs,
  pkgs,
  ...
} @ args:
let
  inherit (lib) mkMerge mkIf;
  cfg = config.dots;
in
with lib; {
  options = {
    # namespace for my dots
    dots = {
      preset = mkOption {
        description = "A list of presets for my commonly used machines";
        type = types.enum [
          "minimal"
          "archbox"
          "surface"
          "linode"
          "droid"
          "darwin-work"
        ];
        default = "minimal";
      };

      wayland = {
        enable = mkEnableOption "graphical environment";
        touchScreen = mkEnableOption "touch screen features";
      };
      darwin.enable = mkEnableOption "MacOS features";
    };
  };

  imports = [./terminal ./presets.nix ./darwin];
  config = mkMerge [
    # (mkIf cfg.wayland.enable {
    #   imports = [./wayland inputs.hyprland.homeManagerModules.default];
    # })
    (mkIf cfg.darwin.enable (import ./darwin args))
  ];
}
