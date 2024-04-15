{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./fonts.nix
    ./anyrun
    ./dunst
    ./eww
    ./foot
    ./gtk
    ./menu
    ./hyprland
    ./sway
    ./swayidle
    ./input
  ];

  config = lib.mkIf config.dots.wayland.enable {
    home.packages = with pkgs; [
      # utilities
      foot
      brightnessctl
      pulseaudio # TODO migrate to pipewire fully (with pw-cli)
      pavucontrol
      wf-osk
      libsForQt5.index

      # general user apps
      mpv
      helix
      dex
      nextcloud-client
      xournalpp
      noisetorch
      xdragon
    ];
  };
}
