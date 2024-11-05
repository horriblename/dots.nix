{pkgs, ...}: {
  imports = [
    ./options.nix
    ./desktop
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  environment.systemPackages = with pkgs; [
    git
  ];

  programs.zsh.enable = true;

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 14d";
    };
  };
}
