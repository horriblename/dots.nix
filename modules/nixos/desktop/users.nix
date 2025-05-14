{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  users = mkIf config.dots.wayland.enable {
    groups.py = {};
    users.py = {
      shell = pkgs.zsh;
      group = "py";
      isNormalUser = true;
      extraGroups = ["wheel" "input" "disk"];
    };
  };
}
