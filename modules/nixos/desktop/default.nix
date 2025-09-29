{...}: {
  imports = [
    ./apps
    ./apps.nix
    ./security.nix
    ./login.nix
    ./input.nix
    ./wayland.nix
    ./gaming.nix
    ./users.nix
  ];
}
