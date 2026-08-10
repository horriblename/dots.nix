{
  lib,
  config,
  pkgs,
  impurity,
  ...
}: let
  inherit (lib.lists) optionals;
in {
  packages = with pkgs;
    [
      lf

      xdg-utils
      # preview tools
      bat
      glow
      # FIXME broken package
      # haskellPackages.pdftotext

      # archive tools
      # zip
      # p7zip
      # unzip
      # gnutar
      # gzip
      # xz
      (unp.override {
        extraBackends = [
          # file, unzip & gzip already included
          binutils
          bzip2
          unrar-wrapper
          gnutar
          xz
        ];
      })

      # others
      #pdfgrep
    ]
    # additional preview tools that only make sense on a desktop
    ++ (optionals config.dots.wayland.enable [
      chafa
      catdoc
      catdocx
      perlPackages.FileMimeInfo
    ]);

  xdg.config.files = {
    "lf/lfrc".text = ''
      set previewer ${impurity.link ./preview}
      source ${impurity.link ./lfrc}
    '';
    "lf/icons".text = builtins.readFile ./icons;
  };
}
