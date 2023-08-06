{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "lf";
  version = "git";

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "lf";
    rev = "efa7787f239afc465131ae217fcb9c7830f6e3ee";
    hash = "sha256-msL1flJ0c0qfAp5crfyZAjD6ehrSP1dwAcf4r8UftMo=";
  };

  vendorHash = "sha256-Mfrvf2QP1yGHdLEtloWVB/Ji7pJ/nHknAxhELIhpIIw=";

  nativeBuildInputs = [installShellFiles];

  ldflags = ["-s" "-w" "-X main.gVersion=r${version}"];

  # Force the use of the pure-go implementation of the os/user library.
  # Relevant issue: https://github.com/gokcehan/lf/issues/191
  tags = lib.optionals (!stdenv.isDarwin) ["osusergo"];

  postInstall = ''
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
    installManPage lf.1
    installShellCompletion etc/lf.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${version}";
    license = licenses.mit;
    maintainers = with maintainers; [dotlambda];
  };
}
