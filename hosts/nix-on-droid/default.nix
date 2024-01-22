{pkgs, ...}: {
  environment.packages = with pkgs; [
    neovim
    busybox
    git
  ];

  system.stateVersion = "23.05";
}
