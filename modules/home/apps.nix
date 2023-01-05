{ inputs, pkgs, config, ... }:
{
  home.packages = with pkgs; [

    # utilities
    foot
    pavucontrol

    # general user apps
    mpv
    xournalpp
  ];
}
