{pkgs, ...}: let
  inherit (builtins) concatStringsSep;

  llama-server = "${pkgs.llama-cpp}/bin/llama-server";
  qwen3-coder-model = "/home/py/.ollama/models/blobs/sha256-1194192cf2a187eb02722edcc3f77b11d21f537048ce04b67ccf8ba78863006a";

  llamaSwapConfigFile = pkgs.writers.writeYAML "config.yml" llamaSwapConfig;
  llamaSwapConfig = {
    models = {
      "qwen3-coder:30b" = {
        cmd = concatStringsSep " " [
          "${llama-server}"
          "--port \${PORT}"
          "-m ${qwen3-coder-model}"
          "--ctx-size 16000"
          "--threads 15"
          "--n-gpu-layers 0"
        ];
        ttl = 30 * 60; # in seconds
        aliases = ["qwen3-coder"];
      };
    };
  };
in {
  config = {
    systemd.user.services = {
      llama-swap = {
        Service = {
          Type = "simple";
          ExecStart = concatStringsSep " " [
            "${pkgs.llama-swap}/bin/llama-swap"
            "--listen 127.0.0.1:11434"
            "--config ${llamaSwapConfigFile}"
          ];
          Restart = "always";
          RestartSec = 10;
          WantedBy = ["default.target"];

          Nice = 19;
          IOSchedulingClass = "idle";
        };

        # from https://www.nijho.lt/post/llama-nixos/#compiler-flags-matter
        # IDK why really
        # environment = {
        #   PATH = mkForce "/run/current-system/sw/bin";
        #   LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
        # };
      };
    };
  };
}
