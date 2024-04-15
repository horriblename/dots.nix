{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.dots.wayland.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "FiraCode Nerd Font:size=12";
          include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
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
  };
}
