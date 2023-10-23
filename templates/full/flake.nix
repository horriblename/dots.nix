{
  description = "A very basic flake";
  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs ["x86_64-linux"];
    pkgsFor = eachSystem (
      system:
        import nixpkgs {
          localSystem = system;
          overlays = [self.overlays.default];
        }
    );
  in {
    overlays = {
      default = final: prev: {
        hello = final.callPackage ./hello.nix {};
      };
    };

    packages = eachSystem (system: {
      default = self.packages.${system}.hello;
      inherit (pkgsFor.${system}) hello;
    });
    devShells = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [];
      };
    });
  };
}
