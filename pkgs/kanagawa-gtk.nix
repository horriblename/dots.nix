{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-themes-extra,
  gtk-engine-murrine,
  # TODO human readable override and assertions
  theme-suffix ? "BL",
  # TODO legacy buttons
}:
stdenvNoCC.mkDerivation rec {
  pname = "kanagawa-gtk";
  version = "git";

  src = fetchFromGitHub {
    repo = "Kanagawa-GKT-Theme";
    owner = "Fausto-Korpsvart";
    rev = "7b8ece4382533491e82f9b3d5552607f67a79999";
    sha256 = "sha256-Jtu04SKXk0wFRvx2Duz0YxHEWJ2sM8ZIT+dtdJqKykY=";
  };

  nativeBuildInputs = [gtk3];

  buildInputs = [gnome-themes-extra];

  propagatedUserEnvPkgs = [gtk-engine-murrine];

  installPhase = ''
    runHook preInstall

    export HOME=$(mktemp -d)

    # TODO install, set perm
    mkdir -p $out/share/themes
    cp -r "./themes/Kanagawa-${theme-suffix}" $out/share/themes
    cp -r "./icons" $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "A GTK theme with the Kanagawa colour palette";
    homepage = "https://github.com/catppuccin/gtk";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [maintainers.fufexan];
  };
}
