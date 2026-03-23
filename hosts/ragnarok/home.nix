{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    ./llama.nix
  ];

  programs.nvf.settings.vim = {
    languages = {
      clang.enable = mkForce true;
      go.enable = mkForce true;
      haskell.enable = mkForce true;
      html.enable = mkForce true;
      lua.enable = mkForce true;
      tex.enable = mkForce true;
    };

    assistant.avante-nvim = {
      enable = true;
      setupOpts = {
        provider = "ollama";
        providers = {
          ollama = {
            endpoint = "http://127.0.0.1:11434";
            timeout = 30000; # Timeout in milliseconds
            model = "qwen3-coder:30b";
            extra_request_body = {
              options = {
                temperature = 0.75;
                keep_alive = 3600;
              };
            };
          };
        };

        rag_service = {
          enabled = false;
          runner = "nix";
          host_mount = lib.generators.mkLuaInline "os.getenv('HOME') .. '/repo'";
          llm = {
            provider = "ollama";
            endpoint = "http://127.0.0.1:11434";
            api_key = "";
            model = "shmily_006/Qw3";
          };
          embed = {
            provider = "ollama";
            endpoint = "http://127.0.0.1:11434";
            api_key = "";
            model = "embeddinggemma";
          };
        };
      };
    };
  };
}
