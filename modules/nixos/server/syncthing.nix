# NOTE: enable the service in host configuration
{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.services.syncthing;
in {
  config = mkIf cfg.enable {
    services = {
      syncthing = {
        openDefaultPorts = true;
        inherit (config.home-manager.users.py.services.syncthing) settings;
      };
    };
  };
}
