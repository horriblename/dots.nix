{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  mkHyprlandService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target"];
    Unit.After = ["hyprland-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };
  hlDebugMonitor = ''
    monitor=WL-1,${
      if config.dots.preset == "surface"
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
in {
  config = lib.mkIf config.dots.wayland.enable {
    home.packages = [
      pkgs.libnotify
      pkgs.catppuccin-cursors.mochaRosewater
      #wf-recorder
      pkgs.brightnessctl
      pkgs.slurp
      pkgs.tesseract5
      pkgs.swappy
      ocr
      pkgs.grim
      screenshot
      pkgs.wl-clipboard
      #pngquant
      pkgs.cliphist
      pkgs.swaybg
      pkgs.swayidle
      pkgs.nwg-drawer
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      extraConfig = ''
        source = ${./options.conf}
        source = ${./hardware.conf}
        source = ${./theme.conf}
        source = ${./winrules.conf}
        source = ${./keybinds.conf}
        source = ${./autostart.conf}

        bind=ALT,SPACE,exec,${config.menu.launcher}

        ${lib.optionalString config.dots.wayland.touchScreen ''
          bindr=SUPER,SUPER_L,exec, eww open dock --toggle
          source = ${./touch-gestures.conf}
        ''}
      '';
      plugins =
        [
          inputs.hyprspace.packages.${pkgs.system}.default
          # "${inputs.hyprland-border-actions.packages.${pkgs.system}.default}/lib/libborder-actions.so"
        ]
        ++ lib.optional config.dots.wayland.touchScreen inputs.hyprgrass.packages.${pkgs.system}.default;
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

      nwg-drawer = mkHyprlandService {
        Unit.Description = "nwg-drawer Daemon";
        Service = {
          ExecStart = "${pkgs.nwg-drawer}/bin/nwg-drawer -r";
          Restart = "always";
        };
      };

      dunst = mkHyprlandService {
        Unit.Description = "Dunst notification daemon";

        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = "${pkgs.dunst}/bin/dunst -config ${./dunstrc}";
        };
      };
    };
  };
}
