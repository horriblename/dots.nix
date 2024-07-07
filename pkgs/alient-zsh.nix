{
  stdenvNoCC,
  source,
}: let
  version = "unknown";
in
  stdenvNoCC.mkDerivation {
    name = "alien-prompt";
    inherit version;

    src = source;

    installPhase = ''
      cp -r $src $out
    '';
  }
