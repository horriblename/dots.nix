{
  pkgs,
  lib,
  config,
  inputs,
  impurity,
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
  imports = [
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];

  config = lib.mkIf config.dots.wayland.enable {
    home.packages = [
      pkgs.libnotify
      #wf-recorder
      pkgs.brightnessctl
      pkgs.slurp
      pkgs.tesseract5
      pkgs.swappy
      pkgs.playerctl
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

    programs.hyprcursor-phinger.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      extraConfig = ''
        source = ${impurity.link ./options.conf}
        source = ${impurity.link ./hardware.conf}
        source = ${impurity.link ./theme.conf}
        source = ${impurity.link ./winrules.conf}
        source = ${impurity.link ./keybinds.conf}
        source = ${impurity.link ./autostart.conf}

        bind=ALT,SPACE,exec,${config.menu.launcher}

        ${lib.optionalString config.dots.wayland.touchScreen ''
          source = ${./touch-gestures.conf}
          device {
            name = surface-pro-3/4-buttons
            kb_file = ${impurity.link ./surface-key.xkb}
          }
        ''}
      '';
      plugins =
        [
          "${inputs.hyprland-xdg-toplevel-move.packages.${pkgs.system}.default}/lib/libexample.so"
          inputs.hyprspace.packages.${pkgs.system}.default
          # "${inputs.hyprland-border-actions.packages.${pkgs.system}.default}/lib/libborder-actions.so"
        ]
        ++ lib.optional config.dots.wayland.touchScreen inputs.hyprgrass.packages.${pkgs.system}.default;
    };

    xdg.configFile = {
      "hypr/hyprlandd.conf".text =
        hlDebugMonitor
        + ''
          source = ${impurity.link ./hyprlandd.conf}
        '';
      "hypr/scripts".source = impurity.link ./scripts;
      "xdg-desktop-portal/hyprland-portals.conf".source = impurity.link ./hyprland-portals.conf;
    };

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
