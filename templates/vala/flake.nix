{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
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
        hello = final.callPackage ./default.nix {};
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
        shellHook = ''
          printf '\x1b[33mHint: build with\x1b[0m\n'
          echo '    meson setup build'
          echo '    meson compile -C build'
        '';
        nativeBuildInputs = with pkgs; [meson ninja pkg-config vala gtk4];
      };
    });
  };
}
