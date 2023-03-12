{ nixpkgs, home-manager, pkgs, ... }:
let
  lf-version = "28";
in
{
  home.packages = with pkgs; [
    xdg-utils
    chafa
  ];
  programs.lf = {
    enable = true;
    package = (pkgs.lf.overrideAttrs (prevAttrs: {
      version = lf-version;
      src = pkgs.fetchFromGitHub {
        owner = "horriblename";
        repo = "lf";
        rev = "r${lf-version}";
        hash = "sha256-VEXWjpdUP5Kabimp9kKoLR7/FlE39MAroRBl9au2TI8=";
      };
    }));
    extraConfig = builtins.readFile ./lfrc;
    previewer.source = ./preview;
  };

  xdg.configFile."lf/icons".text = builtins.readFile ./icons;
}
