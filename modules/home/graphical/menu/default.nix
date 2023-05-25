{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  selectorScript = pkgs.writeShellScriptBin "selectorMenu" ''
    #!/bin/bash
    ${config.menu.selector}
  '';
in {
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

  config.home.packages = [selectorScript];
}
