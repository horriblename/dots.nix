{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.enable {
    services.greetd = {
      enable = true;
    };
    programs.regreet = {
      enable = true;
    };
  };
}
