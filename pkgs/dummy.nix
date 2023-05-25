# NOTE this is used for building packages via github actions
{
  lib,
  stdenvNoCC,
  buildInputs ? [],
}:
stdenvNoCC.mkDerivation {
  name = "github-actions-builder";
  src = ./.;
  propagatedUserEnvPkgs = buildInputs;

  installPhase = ''
    mkdir -p $out/share
    echo "" > $out/share/dummy
  '';

  meta = with lib; {
    description = "Dummy package used to build other packages in Github Actions";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
