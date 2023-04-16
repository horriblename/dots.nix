{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.machineName = mkOption {
    type = types.enum [
      "archbox"
      "surface"
    ];
    default = "archbox";
  };
}
