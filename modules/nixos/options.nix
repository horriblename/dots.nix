{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in {
  options = {
    dots.preset = mkOption {
      description = "preset name";
      type = enum ["base" "desktop"];
      default = "base";
    };
  };
}
