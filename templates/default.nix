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
  dap = {
    path = ./dap;
    description = "Template launch.json for Debug Adapter (DAP)";
  };
  c = {
    path = ./c;
    description = "Simple C project";
  };
  elm = {
    path = ./elm;
    description = "Simple Elm project";
  };
  go = {
    path = ./go;
    description = "Simple Go project";
  };
  rust = {
    path = ./rust;
    description = "Simple Rust project";
  };
  vala = {
    path = ./vala;
    description = "Simple Vala project";
  };
  python = {
    path = ./python;
    description = "Simple Python project";
  };
  haskellStack = {
    path = ./haskellStack;
    description = "Simple Haskell project with stack";
  };
}
