{
  stdenv,
  gcc,
  libffi,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "libcallex-vim";
  version = "git";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "libcallex-vim";
    rev = "5b1d636910f492239f52af641082dc54bd421acf";
    hash = "sha256-kYNU1e1V8FRK6ayIpymOErYvEN10YIPb6g/mP4o0J58=";
  };

  nativeBuildInputs = [gcc];
  buildInputs = [libffi];

  buildPhase = ''
    make -C autoload
  '';

  installPhase = ''
    mkdir -p $out/autoload
    (cd autoload && find . -name '*.vim' -exec cp --parent '{}' "$out/autoload" \;)
    cp autoload/libcallex.so $out/autoload
  '';
}
