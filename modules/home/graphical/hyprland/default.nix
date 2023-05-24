{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  mkHyprlandService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target"];
    Unit.After = ["hyprland-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };
  hlDebugMonitor = ''
    monitor=WL-1,${
      if config.machineName == "surface"
      then "1228x847"
      else "1878x1080"
    },auto,1
  '';
  ocr = pkgs.writeShellScriptBin "ocr" ''
    #!/bin/bash
    set -e
    hyprctl keyword animation "fadeOut,0,5,default"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b eebebe66)" /tmp/ocr.png
    hyprctl keyword animation "fadeOut,1,5,default"
    tesseract /tmp/ocr.png /tmp/ocr-output
    wl-copy < /tmp/ocr-output.txt
    notify-send "OCR" "Text copied!"
    rm /tmp/ocr-output.txt -f
  '';
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    #!/bin/bash
    set -e
    hyprctl keyword animation "fadeOut,0,5,default"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5e81ac66)" - \
      | ${pkgs.swappy}/bin/swappy -f -
    hyprctl keyword animation "fadeOut,1,5,default"
  '';

  mkPluginSo = plugin: soName: "${plugin}/lib/${soName}";
  loadHyprlandPlugins = pluginsSo:
    builtins.concatStringsSep "\n"
    (map (so: "plugin = ${so}") pluginsSo);

  hlPluginsSo =
    [
      (mkPluginSo inputs.hyprland-border-actions.packages.${pkgs.system}.default "libborder-actions.so")
    ]
    ++ lib.optionals config.enableTouchScreen [
      (mkPluginSo inputs.hyprland-touch-gestures.packages.${pkgs.system}.default "libtouch-gestures.so")
    ];
in {
  home.packages = with pkgs; [
    libnotify
    catppuccin-cursors.mochaRosewater
    #wf-recorder
    brightnessctl
    slurp
    tesseract5
    swappy
    ocr
    grim
    screenshot
    wl-clipboard
    #pngquant
    cliphist
    swaybg
    swayidle
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    # package = inputs.hyprland.packages.${pkgs.system}.default.override {
    #   nvidiaPatches = true;
    # };
    extraConfig = ''
      source = ${./options.conf}
      source = ${./hardware.conf}
      source = ${./theme.conf}
      source = ${./winrules.conf}
      source = ${./keybinds.conf}
      source = ${./autostart.conf}
      ${lib.optionalString config.enableTouchScreen ''
        source = ${./touch-gestures.conf}
      ''}
      ${loadHyprlandPlugins hlPluginsSo}
    '';
  };

  xdg.configFile."hypr/hyprlandd.conf".text = hlDebugMonitor + builtins.readFile ./hyprlandd.conf;
  xdg.configFile."hypr/scripts".source = ./scripts;

  systemd.user.services = {
    swaybg = mkHyprlandService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i %h/Pictures/wallpapers/wallpaper.png";
        Restart = "always";
      };
    };
    swayidle = mkHyprlandService {
      Unit.Description = "Idle handler";
      Service = {
        ExecStart = "${lib.getExe pkgs.swayidle}";
        Restart = "always";
      };
    };
    cliphist = mkHyprlandService {
      Unit.Description = "Clipboard history";
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "always";
      };
    };
  };
}
