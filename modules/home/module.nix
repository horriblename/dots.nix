{lib, ...}:
with lib; {
  options.homeConfigurationMode = mkOption {
    type = types.enum [
      "cli-tools"
      "graphical"
    ];
    description = ''
      What level of configuration do you want with home-manager?
      "cli-tools" gives a fully-fledged cli environment
      "graphical" also installs GUI apps + hyprland
    '';
  };

  options.machineName = mkOption {
    type = types.enum [
      "archbox"
      "surface"
      "droid"
    ];
    default = "archbox";
  };
}
