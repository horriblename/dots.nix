{ config, lib, pkgs, ... }:
{
  home.packages = [
    swayidle
  ];

  xdg.configFile."swayidle/config".text = builtins.readFile ./config;
}
