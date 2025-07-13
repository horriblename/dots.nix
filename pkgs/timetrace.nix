{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  version = "v0.14.3";
in
  buildGoModule {
    pname = "timetrace";
    inherit version;
    src = fetchFromGitHub {
      owner = "dominikbraun";
      repo = "timetrace";
      rev = version;
      hash = "sha256-qrAel/ls2EKJSnKXjVC9RNsFaaqGr0R8ScHvqEiOHEI=";
    };

    vendorHash = "sha256-bcOH/CLCQBIG5d9XUtgIswJd+g5F2imaY6LdqKdvfHo=";

    meta = {
      mainProgram = "timetrace";
    };
  }
