{
  lib,
  buildRustPackage,
  imagemagick,
  fetchFromGitHub,
}:
buildRustPackage {
  pname = "vim-graphical-preview";
  version = "git";

  src = fetchFromGitHub {
    owner = "bytesnake";
    repo = "vim-graphical-preview";
    rev = "d5692493d33d5c9d776e94c9d77493741a3293c8";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    imagemagick
  ];

  meta = {
    description = "Small plugin for Vim to display graphics with SIXEL characters";
    homepage = "https://github.com/bytesnake/vim-graphical-preview";
    license = lib.licenses.mit;
  };
}
