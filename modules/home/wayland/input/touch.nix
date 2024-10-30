{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  mkHyprlandService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target"];
    Unit.After = ["hyprland-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };
in {
  config = mkIf config.dots.wayland.touchScreen {
    i18n.inputMethod.fcitx5.addons = [
      inputs.fcitx-virtual-keyboard-adapter.packages.${pkgs.system}.default
    ];

    home.packages = [pkgs.wvkbd];

    xdg.configFile."fcitx5/conf/virtualkeyboardadapter.conf".text = ''
      ActivateCmd="systemctl kill --signal=SIGUSR2 --user wvkbd.service"
      DeactivateCmd="systemctl kill --signal=SIGUSR1 --user wvkbd.service"
    '';

    systemd.user.services = {
      wvkbd = mkHyprlandService {
        Unit.Description = "On Screen Keyboard";
        Service = {
          ExecStart = "${lib.getExe pkgs.wvkbd} --hidden";
          Restart = "always";
        };
      };
    };
  };
}
