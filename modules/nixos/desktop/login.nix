{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.enable {
    environment.systemPackages = [pkgs.onboard];
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          indicators = ["~language" "~a11y" "~session" "~clock" "~power"];
          extraConfig = ''
            keyboard=onboard
          '';
        };
      };
    };
  };
}
