{config, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    extraConfig =
      ''
        set $menu ${config.menu.launcher}
      ''
      + builtins.readFile ./config;
  };
}
