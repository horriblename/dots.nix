{lib, ...}:
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
          "deck"
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

  imports = [./terminal ./presets.nix ./darwin ./wayland];
}
