# TODO wrap package; build hyprworkspaces.go
{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
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
      hyprworkspaces

      ## unlisted deps
      # networkmanager
    ];
  };
}
