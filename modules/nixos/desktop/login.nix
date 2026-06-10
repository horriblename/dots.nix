{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
in {
  config = mkMerge [
    {
      services.displayManager.gdm.enable = config.dots.wayland.enable;
    }

    # intentionally split this way to allow easy overriding of gdm.enable
    (mkIf config.services.displayManager.gdm.enable {
      environment.systemPackages = [pkgs.onboard];
      security.pam.services.gdm.enableGnomeKeyring = true;
    })
  ];
}
