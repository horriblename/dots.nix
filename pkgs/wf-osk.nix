{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-layer-shell,
  gtkmm3,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
}:
stdenv.mkDerivation {
  pname = "wf-osk";
  version = "git-01-09-2020";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-osk";
    rev = "d2e2e3228913ffa800ca31402820d2d90619279e";
    hash = "sha256-FpVnvkZbeubgwP2wGoocmw5u9E9MgK6WHEFkVEo1sUA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    gtkmm3
    gtk-layer-shell
    wayland
    wayland-protocols
  ];
  outputs = ["out"];
  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-touch";
    license = licenses.mit;
    description = "Simple on screen keyboard";
    platforms = platforms.all;
  };
}
