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
    owner = "gokcehan";
    repo = "lf";
    rev = "dd8294952f3cda8d8671847a5ab4dc3613a2aabd";
    hash = "sha256-brjB3KwHWRoDmVbYLDS+gr5Z+xLJCrpQMJIH2+D5wN8=";
  };

  vendorHash = "sha256-Nw58145nYclykXJVmmx5DQjzzP4xtdgWZL6vvK9pzUQ=";

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
