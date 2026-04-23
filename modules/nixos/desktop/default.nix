{...}: {
  imports = [
    ./apps
    ./apps.nix
    ./gaming.nix
    ./input.nix
    ./login.nix
    ./nix-daemon.nix
    ./security.nix
    ./udev.nix
    ./users.nix
    ./wayland.nix
  ];
}
