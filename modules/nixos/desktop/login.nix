{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.enable {
    environment.systemPackages = [pkgs.onboard];
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
      };
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface".scaling-factor = 2.0;
            "org/gnome/desktop/a11y/applications".screen-keyboard-enabled = true;
          };
        }
      ];
    };
  };
}
