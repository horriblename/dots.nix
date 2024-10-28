{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  selectorScript = pkgs.writeShellScriptBin "selectorMenu" ''
    exec ${config.menu.selector}
  '';
  clipboardSelector = pkgs.writeShellScriptBin "clipboardSelector" ''
    cliphist list | ${config.menu.selector} | cliphist decode | wl-copy
  '';
in
  mkIf config.dots.wayland.enable {
    options.menu = {
      selector = mkOption {
        type = types.str;
        description = "Generic selector command (like dmenu)";
      };
      launcher = mkOption {
        type = types.str;
        description = "Bash command to toggle App launcher";
      };
    };

    config.home.packages = [selectorScript clipboardSelector];
  }
