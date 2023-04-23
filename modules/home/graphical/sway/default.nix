{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = builtins.readFile ./config;
  };
}
