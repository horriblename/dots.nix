{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = builtins.readFile ./config.vim;
    };
  };
}
