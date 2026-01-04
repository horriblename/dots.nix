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

    home.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    };
  }
