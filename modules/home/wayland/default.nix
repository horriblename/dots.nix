{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./audio.nix
    ./fonts.nix

    ./eww
    ./desktop
    ./foot
    ./gtk
    ./hyprland
    ./input
    ./menu
    ./qt
    ./sway
    ./swayidle
    ./tofi
  ];

  config = lib.mkIf config.dots.wayland.enable {
    home.packages = with pkgs; [
      # utilities
      foot
      brightnessctl
      pulseaudio # TODO migrate to pipewire fully (with pw-cli)
      pavucontrol
      wvkbd
      libsForQt5.index

      # general user apps
      (mpv.override {scripts = [mpvScripts.mpris];})
      dex
      nextcloud-client
      xournalpp
      noisetorch
      xdragon
    ];
  };
}
