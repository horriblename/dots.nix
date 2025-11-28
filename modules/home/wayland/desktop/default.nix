# WM agnostic desktop services
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  mkWmService = lib.recursiveUpdate {
    Unit.PartOf = ["wayland-wm-session.target"];
    Unit.After = ["wayland-wm-session.target"];
    Install.WantedBy = ["wayland-wm-session.target"];
  };
in {
  config = mkIf config.dots.wayland.enable {
    services.gnome-keyring.enable = true;
    systemd.user = {
      targets = {
        wayland-wm-session = {
          Unit = {
            Description = "Wayland WM Session";
            After = ["graphical-session-pre.target"];
            BindsTo = ["graphical-session.target"];
            Wants = ["graphical-session-pre.target"];
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      };

      services = {
        swaybg = mkWmService {
          Unit.Description = "Wallpaper chooser";
          Service = {
            ExecStart = "${lib.getExe pkgs.swaybg} -i %h/Pictures/wallpapers/wallpaper.png";
            Restart = "always";
          };
        };
        swayidle = mkWmService {
          Unit.Description = "Idle handler";
          Service = {
            ExecStart = "${lib.getExe pkgs.swayidle}";
            Restart = "always";
          };
        };
        cliphist = mkWmService {
          Unit.Description = "Clipboard history";
          Service = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
            Restart = "always";
          };
        };

        nwg-drawer = mkWmService {
          Unit.Description = "nwg-drawer Daemon";
          Service = {
            ExecStart = "${pkgs.nwg-drawer}/bin/nwg-drawer -r";
            Restart = "always";
          };
        };

        dunst = mkWmService {
          Unit.Description = "Dunst notification daemon";

          Service = {
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ExecStart = "${pkgs.dunst}/bin/dunst -config ${./dunstrc}";
          };
        };
      };
    };
  };
}
