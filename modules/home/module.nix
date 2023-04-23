{lib, ...}:
with lib; {
  options.machineName = mkOption {
    type = types.enum [
      "archbox"
      "surface"
      "droid"
    ];
    default = "archbox";
  };
}
