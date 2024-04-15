{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    wayland.windowManager.sway = {
      enable = true;
      extraConfig =
        ''
          set $menu ${config.menu.launcher}
        ''
        + builtins.readFile ./config;
    };
  };
}
