{ config, lib, pkgs, ... }:
let
  configuredLisgd = pkgs.lisgd.overrideAttrs (finalAttrs: previousAttrs: {
    conf = ./config.h;
  });
in
{
  home.packages = [
    configuredLisgd
  ];

}
