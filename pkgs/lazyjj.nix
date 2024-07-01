{
  stdenvNoCC,
  fetchzip,
}: let
  version = "0.2.1";
in
  stdenvNoCC.mkDerivation {
    name = "lazyjj";
    inherit version;

    src = fetchzip {
      url = "https://github.com/Cretezy/lazyjj/releases/download/v0.2.1/lazyjj-v0.2.1-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-yMfGWuzsl94elFxRvGaLA61KBopBnBT3j5pxbCrKl0w=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m755 -D $src/lazyjj $out/bin/lazyjj
      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/Cretezy/lazyjj";
      description = "TUI for jj";
      mainProgram = "lazyjj";
      platforms = ["x86_64-linux"];
    };
  }
