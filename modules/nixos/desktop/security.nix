{
  pkgs,
  lib,
  config,
  ...
}:
lib.modules.mkIf (config.dots.preset == "desktop") {
  services = {
    udev.packages = [pkgs.yubikey-personalization];
    pcscd.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
