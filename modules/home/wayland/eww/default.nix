# TODO wrap package; build hyprworkspaces.go
{
  pkgs,
  config,
  lib,
  impurity,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    programs.eww = {
      enable = true;
    };

    xdg.configFile."eww".source = impurity.link ./config;

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
