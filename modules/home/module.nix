{
  lib,
  config,
  ...
}:
with lib; {
  options.machineName = mkOption {
    type = types.enum [
      "archbox"
      "surface"
      "linode"
      "droid"
    ];
    default = "archbox";
  };

  options.enableTouchScreen = mkEnableOption "Enable touch screen features";

  config.enableTouchScreen = config.machineName == "surface";
}
