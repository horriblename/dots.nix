{
  lib,
  config,
  ...
}: let 
  presets = {
    minimal = {};
    archbox = { wayland.enable = true; };
    surface = {
      wayland = {
        enable = true;
        touchScreen = true;
      };
    };
    linode = {};
    darwin-work = {darwin.enable = true;};
  };
in {
  # config = presets.${config.dots.preset};
}
