{ config, lib, pkgs, ... }:
let
  # configuredLisgd = pkgs.lisgd.override {
  #   inherit lib;
  #   conf = ./config.h;
  # };
in
{
  home.packages = with pkgs; [
    # (lisgd.override { conf = ./config.h; })
    lisgd
  ];

}
