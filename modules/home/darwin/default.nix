{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.darwin.enable {
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
