{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum;
in {
  options = {
    dots = {
      preset = mkOption {
        description = "preset name";
        type = enum ["base" "desktop"];
        default = "base";
      };

      wayland.enable = mkEnableOption "Wayland session" // {default = config.dots.preset == "desktop";};
    };
  };
}
