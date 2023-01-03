{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      ## home manager uses its own cache(?)
      ## nixpkgs get updated more frequently
      ## but hyprland uses cachix, which is separate from nixpkgs, so we can't
      ## use it...(?)
      # inputs.nixpkgs.follow = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager } @ inputs:
    {
      nixosConfigurations = import ./hosts inputs;
    };
}
