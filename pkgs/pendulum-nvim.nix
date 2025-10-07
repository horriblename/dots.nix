{
  src,
  version,
  buildGoModule,
}:
buildGoModule {
  pname = "pendulum-nvim";
  inherit version src;

  modRoot = "remote";
  vendorHash = "sha256-SMMDoJjNMt3+l7yhOBtoMtQbajVtQJU4hZTemf8YtSw=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/doc $out/doc
    cp -r $src/lua $out/lua

    dir="$GOPATH/bin"
    mkdir -p $out/remote
    cp $dir/pendulum-nvim $out/remote

    runHook postInstall
  '';
}
