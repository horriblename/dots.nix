{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  config.systemd.services = {
    nix-daemon = {
      serviceConfig = {
        Nice = 19;
        IOSchedulingPriority = mkForce 7;
      };
    };
  };
}
