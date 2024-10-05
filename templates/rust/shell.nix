{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [cargo rustc rustPackages.clippy];
  RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
}
