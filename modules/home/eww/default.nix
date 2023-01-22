# TODO wrap package; build hyprworkspaces.go
{ config, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config;
  };

  home.packages = with pkgs; [
    brightnessctl
    pulseaudio

    ## unlisted deps
    # networkmanager
  ];
}
