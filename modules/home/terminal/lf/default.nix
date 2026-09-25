{
  lib,
  config,
  pkgs,
  impurity,
  ...
}: let
  inherit (lib.lists) optionals;
in {
  home.packages = with pkgs;
    [
      lf

      xdg-utils
      # preview tools
      bat
      glow
      perlPackages.FileMimeInfo
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
    ++ optionals config.dots.wayland.enable [
      chafa
      catdoc
      catdocx
      poppler-utils
    ];

  xdg.configFile = {
    "lf/lfrc".text = ''
      set previewer ${impurity.link ./preview}
      source ${impurity.link ./lfrc}
    '';
    "lf/icons".text = builtins.readFile ./icons;
  };
}
