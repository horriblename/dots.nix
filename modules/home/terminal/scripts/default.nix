{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  playgroundScript =
    pkgs.writeScriptBin "playground" (builtins.readFile ./playground);
  macos-notify-send =
    pkgs.writeShellScriptBin "notify-send" (builtins.readFile ./notify-send-macos.sh);
in {
  xdg.configFile."playground/templates".source = ./templates;
  home.packages = mkMerge [
    [playgroundScript]
    (mkIf (config.dots.preset == "darwin-work") [macos-notify-send])
  ];
}
