{pkgs, ...}: {
  imports = [
    ./nvim
    ./shell
    ./lf
    ./scripts
    ./lazygit
  ];

  home.packages = with pkgs; [
    # cli tools
    file # lf config dependency
    bat
    trash-cli
    fzf
    ripgrep
    fd
    z-lua
    lua
    zip
    unzip

    # utilities
    btop
    powertop
    nix-du
    asciinema
    graphviz
  ];
}
