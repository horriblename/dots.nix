{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.meta) getExe;

  regreet-niri-conf = pkgs.writeText "regreet-niri.kdl" ''
    spawn-sh-at-startup "${pkgs.regreet}/bin/regreet; niri msg action quit --skip-confirmation"
    spawn-sh-at-startup "${getExe pkgs.wvkbd}"
    hotkey-overlay {
      skip-at-startup
    }

    cursor {
      xcursor-size 48
    }
  '';
in {
  config = mkMerge [
    {
      programs.regreet.enable = config.dots.wayland.enable;
    }

    # intentionally split this way to allow easy overriding of regreet.enable
    (mkIf config.programs.regreet.enable {
      users.users.greeter = {
        isSystemUser = true;
      };

      environment.systemPackages = [pkgs.wvkbd];
      services.greetd.settings = {
        default_session = {
          command = "dbus-run-session ${pkgs.niri}/bin/niri --config ${regreet-niri-conf}";
          user = "greeter";
        };
      };

      programs.regreet.settings = {
        GTK = {
          application_prefer_dark_mode = true;
        };
      };

      systemd.services = {
        greetd.startLimitBurst = 2;
      };
    })
  ];
}
