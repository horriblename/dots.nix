{
  lib,
  buildGoModule,
  ...
}:
buildGoModule {
  pname = "hyprworkspaces";
  version = "0.1";
  src = ./.;

  vendorHash = null;

  meta = with lib; {
    description = "Simple script that listens to hyprland IPC events and shows active workspaces";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
