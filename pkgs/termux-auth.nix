{
  fetchFromGitHub,
  cmake,
  openssl,
  stdenv,
  version ? "1.4",
  termuxHome ? "/data/data/com.termux.nix/files/home",
  termuxPrefix ? "/data/data/com.termux.nix/files/usr",
}:
stdenv.mkDerivation {
  pname = "termux-auth";
  inherit version;
  src = fetchFromGitHub {
    owner = "termux";
    repo = "termux-auth";
    rev = "v${version}";
    hash = "sha256-LbOT3/LQyjhKuqQ3/mMgLP7YTuzC1LYq30Atj9Lv4W8=";
  };

  nativeBuildInputs = [cmake];
  buildInputs = [openssl];

  # FIXME: why is PATH_MAX not defined??
  env.NIX_CFLAGS_COMPILE = ''-DTERMUX_HOME="${termuxHome}" -DTERMUX_PREFIX="${termuxPrefix}" -DPATH_MAX=4096'';

  meta = {
    description = "Password authentication utilities for Termux.";
  };
}
