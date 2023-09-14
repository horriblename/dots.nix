{
  lua,
  stdenvNoCC,
  fetchFromSourcehut,
}:
stdenvNoCC.mkDerivation {
  pname = "fennel-ls";
  version = "git";
  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    hash = "sha256-SAu/i3g1jXMCq/gE9nwxvWQ2eE8qGB4mxvVIzypmVOw=";
    rev = "364d02b90de6e41c40fc31a19665cad20041c63a";
  };

  buildInputs = [lua];
  nativeBuildInputs = [];

  buildPhase = ''
    make
  '';

  installPhase = ''
    export PREFIX="$out"
    make install
  '';

  outputs = ["out"];

  meta = {
    mainProgram = "fennel-ls";
  };
}
