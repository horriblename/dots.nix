{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.anyrun
  ];
  menu.selector = "GTK_THEME='${config.gtk.theme.name}' ${lib.getExe pkgs.anyrun} -o ${pkgs.anyrun}/lib/libstdin.so";
  menu.launcher = "pkill anyrun || GTK_THEME='${config.gtk.theme.name}' ${lib.getExe pkgs.anyrun}";

  xdg.configFile."anyrun/config.ron".text = ''
    Config(
      // `width` and `vertical_offset` use an enum for the value it can be either:
      // Absolute(n): The absolute value in pixels
      // Fraction(n): A fraction of the width or height of the full screen (depends on exclusive zones and the settings related to them) window respectively

      // How wide the input box and results are.
      width: Absolute(800),

      // Where Anyrun is located on the screen: Top, Center
      position: Top,

      // How much the runner is shifted vertically
      vertical_offset: Absolute(40),

      // Hide match and plugin info icons
      hide_icons: false,

      // ignore exclusive zones, f.e. Waybar
      ignore_exclusive_zones: false,

      // Layer shell layer: Background, Bottom, Top, Overlay
      layer: Overlay,

      // Hide the plugin info panel
      hide_plugin_info: false,

      // Close window when a click outside the main box is received
      close_on_click: false,

      // Show search results immediately when Anyrun starts
      show_results_immediately: false,

      // Limit amount of entries shown in total
      max_entries: None,

      // List of plugins to be loaded by default, can be specified with a relative path to be loaded from the
      // `<anyrun config dir>/plugins` directory or with an absolute path to just load the file the path points to.
      plugins: [
        "${pkgs.anyrun}/lib/libapplications.so",
        "${pkgs.anyrun}/lib/libsymbols.so",
        "${pkgs.anyrun}/lib/librink.so",
      ],
    )
  '';
}
