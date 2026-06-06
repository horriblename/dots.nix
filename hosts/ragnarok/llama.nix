{
  pkgs,
  self,
  ...
}: let
  inherit (builtins) concatStringsSep mapAttrs attrValues;

  llama-server-git = "${self.packages.${pkgs.stdenv.system}.llama-cpp}/bin/llama-server";
  llama-server = "${pkgs.llama-cpp}/bin/llama-server";
  qwen3-coder-model = "/home/py/.ollama/models/blobs/sha256-1194192cf2a187eb02722edcc3f77b11d21f537048ce04b67ccf8ba78863006a";

  llamaSwapConfigFile = pkgs.writers.writeYAML "config.yml" llamaSwapConfig;
  buildServerCmd' = cmd: flags:
    "${cmd} "
    + concatStringsSep " " (
      attrValues
      (mapAttrs
        (key: val: "--${key} ${toString val}")
        flags)
    );

  # ttl is in seconds
  mkModel = opt: {ttl = 30 * 60;} // opt;

  llamaSwapConfig = {
    models = {
      "qwen3-coder:30b" = mkModel {
        cmd = buildServerCmd' "${llama-server-git}" {
          model = qwen3-coder-model;
          port = "\${PORT}";
        };
        aliases = ["qwen3-coder"];
      };

      "qwen3-coder-next" = mkModel {
        cmd = buildServerCmd' "${llama-server-git}" {
          hf-repo = "unsloth/Qwen3-Coder-Next-GGUF:UD-Q2_K_XL";
          ctx-size = 32000;
          n-gpu-layers = 0;
          port = "\${PORT}";
          threads = 15;
        };
      };

      "qwen2.5-coder-3b" = mkModel {
        cmd = buildServerCmd' "${llama-server-git}" {
          port = "\${PORT}";
          ctx-size = 4096;
          n-gpu-layers = 0;
          threads = 8;
          temp = "0.1";
        };
      };

      "DeepSeek-Coder-V2-Lite-Base" = mkModel {
        cmd = buildServerCmd' "${llama-server}" {
          hf-repo = "QuantFactory/DeepSeek-Coder-V2-Lite-Base-GGUF";
          n-gpu-layers = 0;
          port = "\${PORT}";
          threads = 8;
          ctx-size = 512;
          temp = 0.1;
        };
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
