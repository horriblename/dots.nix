{
  self,
  inputs,
  pkgs,
  ...
}: {
  nix.package = inputs.lix.packages.${pkgs.system}.nix;
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixgl.flake = inputs.nixgl;
    dots.flake = self;
    agenix.flake = inputs.agenix;
    roc.flake = inputs.roc;
  };

  # TODO move out
  nix.settings = {
    # nix-path = ["nixpkgs=${inputs.nixpkgs}" "dots=${self}"];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://horriblename.cachix.org"
      "https://anyrun.cachix.org"
      "https://cache.lix.systems"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "horriblename.cachix.org-1:FdI7l8gJJNhehkdW66BGcRrwn+14Iy+oC033gyONcs0="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };
}
