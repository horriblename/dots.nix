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
        openDefaultPorts = false;
        inherit (config.home-manager.users.py.services.syncthing) settings;
      };

      caddy = {
        enable = true;
        virtualHosts = {
          "sync.peynch.online" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:22000
            '';
          };
        };
      };
    };
  };
}
