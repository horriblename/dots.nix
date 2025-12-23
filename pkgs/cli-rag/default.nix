{
  src,
  stdenv,
  # nativeBuildInputs
  cli11,
  cmake,
  git,
  ninja,
  pkg-config,
  # buidlInputs
  cmark,
  curl,
  httplib,
  nlohmann_json,
  ixwebsocket,
  esbuild,
  rag-cli-elm,
  zlib,
  # testing
  catch2,
}:
stdenv.mkDerivation {
  pname = "rag-cli";
  version = "git";
  inherit src;

  # NOTE: elm UI is built separately
  nativeBuildInputs = [
    ninja
    cmake
    cli11
    pkg-config
    git
    ixwebsocket
    esbuild
  ];

  buildInputs = [
    nlohmann_json
    curl
    cmark
    httplib
    zlib
    catch2
  ];

  cmakeFlags = ["-DELM_OUTPUT=${rag-cli-elm}/Main.html"];

  patches = [
    ./cli-rag.patch
  ];

  meta = {
    mainProgram = "crag";
    homepage = "https://github.com/the-sett/rag-cli";
  };
}
