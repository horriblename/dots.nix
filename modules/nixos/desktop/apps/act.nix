{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.development.enable {
    environment.systemPackages = [pkgs.act];
    virtualisation.docker = {
      enable = true;
    };

    users.users = {
      py.extraGroups = ["docker"];
    };
  };
}
