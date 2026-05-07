{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  searxNgPort = 5348;
in
  mkIf config.dots.ai.enable {
    services.open-webui = {
      enable = false;
      port = 11435;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        # Disable authentication
        WEBUI_AUTH = "False";

        ENABLE_RAG_WEB_SEARCH = "True";
        RAG_WEB_SEARCH_ENGINE = "searxng";
        RAG_WEB_SEARCH_RESULT_COUNT = "3";
        RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";
        SEARXNG_QUERY_URL = "http://127.0.0.1:${toString searxNgPort}/search?q=<query>";
      };
    };

    services.searx = {
      enable = false;
      environmentFile = /etc/searx/env;
      settings = {
        server = {
          bind_address = "127.0.0.1";
          port = searxNgPort;
        };
        search = {
          formats = ["html" "json"];
        };
      };
    };
  }
