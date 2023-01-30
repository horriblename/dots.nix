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
    jaq

    # screenshot stuff
    grim
    slurp
    fzf
    nsxiv


    ## unlisted deps
    # networkmanager
  ];
}
