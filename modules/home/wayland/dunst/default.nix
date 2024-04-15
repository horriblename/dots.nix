{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    services.dunst = {
      enable = true;
      configFile = ./dunstrc;
    };
  };
}
