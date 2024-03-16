This flake provides a quick way to create a per-machine config.

1. put `flake.nix` in ~/.nixpkgs
2. `nix profile install ~/.nixpkgs`

you can upgrade these packages with
```bash
nix profile upgrade ~/.nixpkgs
```

