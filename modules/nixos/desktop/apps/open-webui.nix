{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in
  mkIf (config.dots.preset == "archbox") {
    services.open-webui = {
      enable = true;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        # Disable authentication
        WEBUI_AUTH = "False";
      };
    };
  }
