{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./nvim
    ./shell
    ./lf
    ./scripts
    ./lazygit
  ];

  home.packages = with pkgs;
    lib.mkMerge
    [
      [
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
        gnumake

        # utilities
        btop
        nix-du
        graphviz
      ]

      (lib.mkIf (!config.dots.darwin.enable) [powertop])
    ];
}
