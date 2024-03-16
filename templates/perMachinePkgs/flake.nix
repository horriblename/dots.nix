# TODO
{
  outputs = {
    nixpkgs,
    dots,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [dots.overlay];
    };
    # inherit (nixpkgs) lib;
  in {
    packages.x86_64-linux.default = pkgs.symlinkJoin {
      name = "per-machine-packages";
      paths = with pkgs; [
        gh
        just
      ];
    };
  };
}
