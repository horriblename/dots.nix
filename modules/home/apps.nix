{ inputs, pkgs, config, ... }:
{
  home.packages = with pkgs; [

    # utilities
    foot
	 brightnessctl
	 pulseaudio # TODO migrate to pipewire fully (with pw-cli)
    pavucontrol
	 squeekboard

    # general user apps
    mpv
    xournalpp
  ];
}
