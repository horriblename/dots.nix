{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkOverride;
in {
  config = mkIf config.services.postgresql.enable {
    services = {
      postgresql = {
        authentication = mkOverride 10 ''
          #type DB      DBuser  auth-method
          local all     all     peer
        '';
      };
    };
  };
}
