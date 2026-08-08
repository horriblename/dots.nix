{
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
    };

    xdg.configFile = {
      "opencode".source = impurity.link ./config;
    };
  };
}
