{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  caddyEnabled = config.services.caddy.enable;
in {
  networking.firewall = mkIf caddyEnabled {
    enable = true;
    allowedTCPPorts = [80 443];
  };
}
