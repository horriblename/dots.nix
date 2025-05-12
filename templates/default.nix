{
  default = {
    path = ./defaultTemplate;
    description = "Simple flake with overlays, packages, and devShells";
  };
  full = {
    path = ./full;
    description = "Extra stuff for direnv, nixd, and flake-compat";
  };
  perMachinePkgs = {
    path = ./perMachinePkgs;
    description = "Quick and dirty per-machine environment";
  };
  dap = {path = ./dap;};
  c = {path = ./c;};
  elm = {path = ./elm;};
  go = {path = ./go;};
  rust = {path = ./rust;};
  vala = {path = ./vala;};
  python = {path = ./python;};
  haskellStack = {path = ./haskellStack;};
}
