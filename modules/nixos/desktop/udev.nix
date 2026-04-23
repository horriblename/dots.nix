{
  lib,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;
in {
  config = {
    services = {
      udev = {
        extraRules =
          mkIf config.dots.development.enable
          (concatStringsSep ", " [
            ''SUBSYSTEM=="tty"''
            ''ATTRS{idVendor}=="0403"''
            ''ATTRS{idProduct}=="6001"''
            ''SYMLINK+="ttyUART"''
            ''MODE=0660''
            ''GROUP="dialout"''
          ]);
      };
    };
  };
}
