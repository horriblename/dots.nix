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
    ./development.nix
  ];

  config = mkIf config.dots.wayland.graphicalApps {
    home.packages = with pkgs;
      [
        # CLI tools
        keep-sorted

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
  };
}
