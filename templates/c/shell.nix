{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  # silences GCC warnings
  hardeningDisable = ["fortify"];
}
