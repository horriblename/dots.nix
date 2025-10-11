{
  pkgs,
  impurity,
  ...
}: {
  home.packages = with pkgs; [
    tofi
    lexend # font
  ];

  xdg.configFile."tofi/config".source = impurity.link ./gruvbox.ini;

  menu = {
    selector = "tofi";
    launcher = "tofi-drun";
  };
}
