{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    libsixel
  ];

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=12";
      };
      colors = {
        alpha = "0.6";
      };
      key-bindings = {
        search-start = "Control+Shift+f";
      };
    };
  };
}
