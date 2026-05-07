{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.ai.enable {
    services.libretranslate = {
      enable = true;
      port = 5000;
    };
  };
}
