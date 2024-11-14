{...}: {
  imports = [
    ./security.nix
    ./login.nix
    ./input.nix
    ./wayland.nix
    ./gaming.nix
  ];

  programs.hyprland = {
    enable = true;
  };
}
