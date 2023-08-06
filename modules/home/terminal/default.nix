{pkgs, ...}: {
  imports = [
    ./nvim
    ./shell
    ./lf
    ./scripts
  ];

  home.packages = with pkgs; [
    # cli tools
    file # lf config dependency
    bat
    trash-cli
    fzf
    ripgrep
    fd
    lazygit
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
