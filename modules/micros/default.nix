{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib) types;
in {
  options = {
    system.build.nixos-rebuild = mkOption {
      type = types.package;
      default = pkgs.nixos-rebuild-ng;
      description = "For nixos-rebuild compatibility";
    };
  };
}
