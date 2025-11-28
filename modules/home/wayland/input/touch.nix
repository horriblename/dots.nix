{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

  mkHyprlandService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target"];
    Unit.After = ["hyprland-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };

  toggleScript =
    pkgs.writeShellScriptBin "osk-control"
    (builtins.readFile ./osk-control.sh);
in {
  config = mkIf config.dots.wayland.touchScreen {
    i18n.inputMethod.fcitx5.addons = [
      inputs.fcitx-virtual-keyboard-adapter.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.packages = [pkgs.wvkbd toggleScript];

    xdg.configFile."fcitx5/conf/virtualkeyboardadapter.conf".text = ''
      ActivateCmd="${getExe toggleScript} activate"
      DeactivateCmd="${getExe toggleScript} deactivate"
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
