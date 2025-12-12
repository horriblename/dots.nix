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
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "16000";
      };
    };
    systemd.user.services = {
      ollama = {
        Service = {
          Nice = 19;
          IOSchedulingClass = "best-effort";
          IOSchedulingPriority = 7;
        };
      };
    };
  };
}
