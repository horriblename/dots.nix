{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;
in {
  imports = [
    ./desktop.nix
    ./touch.nix
  ];

  config = mkIf config.dots.wayland.graphicalApps {
    home.packages = with pkgs;
      [
        firefox
        kdePackages.okular
        image-roll
        onlyoffice-desktopeditors
        # NOTE: manual intervention needed:
        # copy corefonts into ~/.local/share/fonts/truetype/*.ttf
        # (symlinks don't work due to bug)
        # corefonts
      ]
      ++ optionals (config.dots.preset == "surface") [
        rnote
      ];

    nixpkgs.config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "corefonts"
        ];
    };

    services.podman.enable = true;
    # manual setup needed: systemctl --user enable podman.socket
    home.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    };
  };
}
