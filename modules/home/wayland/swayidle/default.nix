{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    home.packages = with pkgs; [
      swayidle
    ];

    xdg.configFile."swayidle/config".text = builtins.readFile ./config;
  };
}
