{
  self,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # utilities
    foot
    brightnessctl
    pulseaudio # TODO migrate to pipewire fully (with pw-cli)
    pavucontrol
    self.packages.${pkgs.system}.wf-osk
    libsForQt5.index

    # general user apps
    mpv
    helix
    dex
    nextcloud-client
    xournalpp
  ];
}
