{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in
  mkIf config.dots.development {
    services.wakapi = {
      enable = true;
      database.dialect = "sqlite3";
    };
  }
