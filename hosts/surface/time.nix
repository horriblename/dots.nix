{pkgs, ...}: let
  # from https://github.com/TruePositiveLab/fake-hwclock
  # licensed under MIT
  fake-hwclock = pkgs.writeShellScript "fake-hwclock" (builtins.readFile ./fake-hwclock);
  tickPath = "/var/lib/fake-hwclock.data";
in {
  systemd = {
    services = {
      fake-hwclock-tick = {
        enable = true;
        description = "Save hwclock by timer";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${fake-hwclock} tick > /dev/null";
        };

        environment = {
          CLOCKFILE = tickPath;
        };
      };

      fake-hwclock = {
        enable = true;
        description = "Fake Hardware Clock";

        requires = ["local-fs.target" "dev-data.device"];
        after = ["local-fs.target"];
        wants = ["time-sync.target"];
        conflicts = ["shutdown.target"];
        before = [
          "shutdown.target"
          "time-sync.target"
          "ntpdate.service"
          "ntpd.service"
        ];

        wantedBy = ["multi-user.target"];

        unitConfig = {
          DefaultDependencies = "No";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${fake-hwclock} load";
          ExecStop = "${fake-hwclock} save";
        };
      };
    };

    timers = {
      fake-hwclock-tick = {
        description = "Save hwclock every 15 minutes";
        wantedBy = ["multi-user.target"];

        timerConfig = {
          OnBootSec = "15min";
          OnUnitActiveSec = "15min";
        };
      };
    };
  };
}
