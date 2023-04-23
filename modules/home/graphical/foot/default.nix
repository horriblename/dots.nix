{
  config,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=12";
      };
      colors = {
        alpha = "0.6";
      };
      cursor = {
        color = "282828 ebdbb2";
      };
      key-bindings = {
        search-start = "Control+Shift+f";
      };
    };
  };
}
