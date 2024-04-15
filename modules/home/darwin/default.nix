{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
