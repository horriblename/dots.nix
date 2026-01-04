{
  lib,
  self,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.strings) hasPrefix getName;
in {
  nixpkgs = {
    overlays = [self.overlay];
    config = {
      allowAliases = false;
      allowUnfreePredicate = pkg:
        elem (getName pkg) [
          "codeium"
          "unityhub"
          "open-webui"
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
          "corefonts"

          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"

          # nvtop-nvidia BS
          "nvidia"
          "cuda-merged"
          "libnvjitlink"
          "libnpp"
        ]
        || hasPrefix "cuda_" (getName pkg)
        || hasPrefix "libcu" (getName pkg);
    };
  };
}
