{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in
  mkIf config.dots.development.enable {
    home.packages = [
      pkgs.act
    ];

    services.podman.enable = true;

    xdg.configFile = {
      "systemd/user/default.target.wants/podman.socket" = {
        source = "${config.services.podman.package}/share/systemd/user/podman.socket";
      };
    };

    systemd.user.services = {
      podman = {
        Unit = {
          Description = "Podman API Service";
          Requires = "podman.socket";
          After = ["podman.socket"];
          Documentation = "man:podman-system-service(1)";
          StartLimitIntervalSec = 0;
        };

        Service = {
          Delegate = true;
          Type = "exec";
          KillMode = "process";
          Environment = [
            # /run/wrappers for NixOS, rest for other distros
            ''PATH=/run/wrappers/bin:/usr/sbin:/usr/bin:/sbin:/bin''
            ''LOGGING="--log-level=info"''
          ];
          ExecStart = "${pkgs.podman}/bin/podman $LOGGING system service";
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };

    home.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    };
  }
