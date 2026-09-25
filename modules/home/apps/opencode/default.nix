{
  pkgs-unstable,
  lib,
  config,
  impurity,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.development.enable {
    programs.opencode = {
      enable = true;
      package = pkgs-unstable.opencode;
    };

    xdg.configFile = {
      "opencode".source = impurity.link ./config;
    };
  };
}
