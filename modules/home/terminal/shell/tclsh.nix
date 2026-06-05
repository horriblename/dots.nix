{
  pkgs,
  impurity,
  ...
}: {
  home.packages = with pkgs; [
    tcl
    tclPackages.tclreadline
  ];

  home.file.".inputrc".source = impurity.link ./.inputrc;
  home.file.".tclshrc".source = impurity.link ./.tclshrc;
}
