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
    ./touch.nix
    ./timetrace.nix
  ];

  config = mkIf config.dots.wayland.graphicalApps {
    home.packages = with pkgs;
      [
        firefox
        kdePackages.okular
        image-roll
        onlyoffice-bin
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
  };
}
