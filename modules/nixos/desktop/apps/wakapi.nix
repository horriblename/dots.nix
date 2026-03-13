{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in
  mkIf config.dots.development.enable {
    services.wakapi = {
      enable = true;
      database.dialect = "sqlite3";
      passwordSaltFile = "/etc/wakapi/salt";
      settings = {
        server.port = 3474;
      };
    };
  }
