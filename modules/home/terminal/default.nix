{
  pkgs,
  config,
  ...
}: let
  # https://discourse.nixos.org/t/nix-flamegraph-or-profiling-tool/33333
  stackCollapse = pkgs.writeTextFile {
    name = "stack-collapse.py";
    destination = "/bin/stack-collapse.py";
    text = builtins.readFile (builtins.fetchurl
      {
        url = "https://raw.githubusercontent.com/NixOS/nix/master/contrib/stack-collapse.py";
        sha256 = "sha256:0mi9cf3nx7xjxcrvll1hlkhmxiikjn0w95akvwxs50q270pafbjw";
      });
    executable = true;
  };
  nixFunctionCalls = pkgs.writeShellApplication {
    name = "nixFunctionCalls";
    runtimeInputs = [stackCollapse pkgs.inferno];
    text = builtins.readFile ./nix-function-calls.sh;
    checkPhase = "";
  };
in {
  imports = [
    ./nvim
    ./shell
    ./lf
    ./scripts
    ./git
    ./zellij
    ./yazi
  ];

  home.packages = with pkgs;
    lib.mkMerge
    [
      [
        # cli tools
        file # lf config dependency
        bat
        delta
        trash-cli
        fzf
        ripgrep
        fd
        z-lua
        lua
        zip
        unzip
        gnumake
        jujutsu
        jjui

        # utilities
        btop
        nix-du
        graphviz
        dust
        nixFunctionCalls
        nh
        npins
      ]

      (lib.mkIf (!config.dots.darwin.enable) [powertop])
    ];
}
