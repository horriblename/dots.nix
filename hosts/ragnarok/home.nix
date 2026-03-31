{
  lib,
  pins,
  ...
}: let
  inherit (lib.modules) mkForce;

  noBuildPlug = pname: let
    pin = pins.${pname};
    version = builtins.substring 0 8 pin.revision;
  in
    pin.outPath.overrideAttrs {
      inherit pname version;
      name = "${pname}-${version}";

      passthru.vimPlugin = false;
    };
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
      tex.enable = mkForce true;
      rust.enable = mkForce true;
    };

    extraPlugins = {
      llama = {package = noBuildPlug "llama.vim";};
    };
  };
}
