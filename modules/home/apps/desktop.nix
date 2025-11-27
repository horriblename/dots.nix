{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.dots.preset == "archbox") {
    services.ollama = {
      enable = true;
    };
  };
}
