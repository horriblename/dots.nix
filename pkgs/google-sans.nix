{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "google-sans";
  version = "unstable-2022-11-14";
  outputs = [ "out" ];

  src = fetchFromGitHub
    {
      owner = "sahibjotsaggu";
      repo = "Google-Sans-Fonts";
      rev = "b1826355d8212378e5fd6094bbe504268fa6f85d";
      sha256 = "09161d81b38dcedf6aa572cfeb559f4b4aea3b4b4e0f7b776c1eed19ea3c3958";
    };

  installPhase = ''
    	mkdir -p $out/share/fonts/TTF
    	cp -va *.ttf $out/share/fonts/TTF
    	'';

  meta = {
    description = "Google Sans";
  };
}
