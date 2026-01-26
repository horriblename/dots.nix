{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in
  mkIf config.dots.ai.enable {
    services.open-webui = {
      enable = true;
      port = 11435;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        # Disable authentication
        WEBUI_AUTH = "False";
      };
    };
  }
