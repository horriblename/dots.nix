{ pkgs
, lib
, config
, inputs
, ...
}:
with lib; let
  mkHyprlandService = lib.recursiveUpdate {
    Unit.PartOf = [ "hyprland-session.target" ];
    Unit.After = [ "hyprland-session.target" ];
    Install.WantedBy = [ "hyprland-session.target" ];
  };
  ocr = pkgs.writeShellScriptBin "ocr" ''
    		#!/bin/bash
    		grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr.png && tesseract /tmp/ocr.png /tmp/ocr-output && wl-copy < /tmp/ocr-output.txt && notify-send "OCR" "Text copied!" && rm /tmp/ocr-output.txt -f
    	'';
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    		#!/bin/bash
    		hyprctl keyword animation "fadeOut,0,8,slow" && ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5e81acd2)" - | swappy -f -; hyprctl keyword animation "fadeOut,1,8,slow"
    	'';
in
{
  home.packages = with pkgs; [
    libnotify
    #wf-recorder
    brightnessctl
    slurp
    tesseract5
    #swappy
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
    '';
  };

  xdg.configFile."hypr/hyprlandd.conf".text = builtins.readFile ./hyprlandd.conf;

  systemd.user.services = {
    swaybg = mkHyprlandService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i $HOME/Pictures/wallpapers/wallpaper.png";
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

