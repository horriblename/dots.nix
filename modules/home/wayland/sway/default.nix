{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    wayland.windowManager.sway = {
      enable = false;
      extraConfig =
        ''
          set $menu ${config.menu.launcher}
        ''
        + builtins.readFile ./config;
    };
  };
}
