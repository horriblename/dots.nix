{pkgs, ...}: let
  playgroundScript =
    pkgs.writeScriptBin "playground" (builtins.readFile ./playground);
in {
  xdg.configFile."playground/templates".source = ./templates;
  home.packages = [
    playgroundScript
  ];
}
