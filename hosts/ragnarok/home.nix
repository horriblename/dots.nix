{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    ./llama.nix
  ];

  programs.nvf.settings.vim = {
    languages = {
      clang.enable = mkForce true;
      go.enable = mkForce true;
      haskell.enable = mkForce true;
      html.enable = mkForce true;
      lua.enable = mkForce true;
      rust.enable = mkForce true;
      typst.enable = mkForce false;
      zig.enable = mkForce true;
    };
  };
}
