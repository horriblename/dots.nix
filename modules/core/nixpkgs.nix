{
  self,
  lib,
  ...
}: {
  nixpkgs = {
    overlays = [self.overlay];
    config = import ./nixpkgs/config.nix {inherit lib;};
  };
}
