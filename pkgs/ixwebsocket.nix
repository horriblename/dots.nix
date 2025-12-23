{
  pin,
  stdenv,
  cmake,
  ninja,
  openssl,
  zlib,
}:
stdenv.mkDerivation {
  pname = "IXWebSocket";
  version = pin.version or (builtins.substring 0 8 pin.revision);
  src = pin;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    zlib
  ];

  meta = {
    homepage = "https://github.com/machinezone/IXWebSocket";
  };
}
