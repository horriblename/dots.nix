This flake provides a quick way to create a per-machine config.

1. put `flake.nix` in ~/.nixpkgs
2. `nix profile install ~/.nixpkgs`

upgrade with:

```bash
nix flake update
nix profile upgrade <profile-id>
```

