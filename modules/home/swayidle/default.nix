{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swayidle
  ];

  xdg.configFile."swayidle/config".text = builtins.readFile ./config;
}
