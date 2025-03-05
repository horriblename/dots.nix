{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  services = mkIf config.dots.wayland.enable {
    udev.packages = [pkgs.yubikey-personalization];
    pcscd.enable = true;

    gnome.gnome-keyring.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
