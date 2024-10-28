{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.lists) optional;
  playgroundScript = pkgs.writeScriptBin "playground" ''
    #!${pkgs.python3}/bin/python
    ${builtins.readFile ./playground}
  '';
  macos-notify-send =
    pkgs.writeShellScriptBin "notify-send" (builtins.readFile ./notify-send-macos.sh);
in {
  home.packages =
    [playgroundScript]
    ++ (optional (config.dots.preset == "darwin-work") macos-notify-send);
}
