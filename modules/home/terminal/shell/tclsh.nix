{
  pkgs,
  impurity,
  ...
}: {
  home.packages = with pkgs; [
    tcl
    tclPackages.tclreadline
  ];

  home.file.".inputrc" = impurity.link ./.inputrc;
  home.file.".tclshrc" = impurity.link ./.tclshrc;
}
