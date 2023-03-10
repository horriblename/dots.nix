{ inputs, pkgs, config, ... }:
{
  home.packages = with pkgs; [
    tofi
    lexend # font
  ];

  xdg.configFile."tofi/gruvbox-menu.ini".text = ''
    font = ${pkgs.lexend}/share/fonts/lexend/Lexend-Regular.ttf
    font-size = 16
    corner-radius = 30
    outline-color = #FE8019
    outline-width = 1
    border-color = #FE8019
    border-width = 1
    background-color = #282828
    text-color = #A2BAB1
    #selection-color = #B8BB26
    selection-color = #FB4924
    selection-match-color = #8EC07C
    #prompt-text = "  "
    prompt-text = "> "
    #num-results = 9
    hide-cursor = true
    width = 30%
    height = 50%
    drun-launch = true
  '';
}
