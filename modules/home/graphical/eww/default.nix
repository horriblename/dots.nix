# TODO wrap package; build hyprworkspaces.go
{
  self,
  pkgs,
  ...
}: {
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
    self.packages.${pkgs.system}.hyprworkspaces

    ## unlisted deps
    # networkmanager
  ];
}
