{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum listOf str;
in {
  options = {
    dots = {
      preset = mkOption {
        description = "preset name";
        type = enum ["base" "desktop"];
        default = "base";
      };

      wayland = {
        enable = mkEnableOption "Wayland session" // {default = config.dots.preset == "desktop";};
        gaming = mkEnableOption "gaming stuff";
      };

      development = {
        enable = mkEnableOption "Development tools" // {default = config.dots.preset == "desktop";};
      };

      ai = {
        enable = mkEnableOption "Electricity Bill Pro Max";
      };

      statePaths = mkOption {
        description = ''
          Option tracking all the stateful files I don't yet know how to deal
          with.
        '';
        type = listOf str;
        default = [];
      };
    };
  };
}
