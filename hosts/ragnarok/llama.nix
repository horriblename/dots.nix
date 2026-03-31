{
  pkgs,
  self,
  ...
}: let
  inherit (builtins) concatStringsSep;

  llama-server-git = "${self.packages.${pkgs.stdenv.system}.llama-cpp}/bin/llama-server";
  llama-server = "${pkgs.llama-cpp}/bin/llama-server";
  qwen3-coder-model = "/home/py/.ollama/models/blobs/sha256-1194192cf2a187eb02722edcc3f77b11d21f537048ce04b67ccf8ba78863006a";

  llamaSwapConfigFile = pkgs.writers.writeYAML "config.yml" llamaSwapConfig;
  buildServerCmd = flags:
    concatStringsSep " " ([
        "${llama-server-git}"
        "--ctx-size 16000"
        "--n-gpu-layers 0"
        "--jinja"
      ]
      ++ flags);

  qwen3CoderServerCmd = port:
    buildServerCmd ["-m ${qwen3-coder-model}" "--port ${port}"];

  # ttl is in seconds
  mkModel = opt: {ttl = 30 * 60;} // opt;

  llamaSwapConfig = {
    models = {
      "qwen3-coder:30b" = mkModel {
        cmd = qwen3CoderServerCmd "\${PORT}";
        aliases = ["qwen3-coder"];
      };

      "qwen3-coder-next" = mkModel {
        cmd = buildServerCmd [
          "-hf unsloth/Qwen3-Coder-Next-GGUF:UD-Q2_K_XL"
          "--port \${PORT}"
          "--threads 15"
        ];
      };

      "qwen2.5-coder-3b" = mkModel {
        cmd = concatStringsSep " " [
          "${llama-server-git}"
          "-hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF"
          "--port \${PORT}"
          "--threads 8"
          "--n-gpu-layers 0"
          "--ctx-size 4096"
          "--temp 0.1"
        ];
      };

      "DeepSeek-Coder-V2-Lite-Base" = mkModel {
        cmd = concatStringsSep " " [
          "${llama-server}"
          "-hf QuantFactory/DeepSeek-Coder-V2-Lite-Base-GGUF"
          "--port \${PORT}"
          "--n-gpu-layers 0"
          "--threads 8"
          "--ctx-size 512"
          "--temp 0.1"
        ];
        aliases = ["DeepSeek-Coder-V2"];
      };
    };
  };
in {
  config = {
    systemd.user = {
      services = {
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
  };
}
