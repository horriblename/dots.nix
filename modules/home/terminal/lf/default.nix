{
  pkgs,
  impurity,
  ...
}: {
  home.packages = with pkgs; [
    lf

    xdg-utils
    # preview tools
    bat
    glow
    catdoc
    catdocx
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
        chafa
        bzip2
        unrar-wrapper
        gnutar
        xz
      ];
    })

    # others
    #pdfgrep
  ];

  xdg.configFile = {
    "lf/lfrc".text = ''
      set previewer ${impurity.link ./preview}
      source ${impurity.link ./lfrc}
    '';
    "lf/icons".text = builtins.readFile ./icons;
  };
}
